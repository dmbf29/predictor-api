class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable # :confirmable
  include DeviseTokenAuth::Concerns::User
  has_many :memberships, dependent: :destroy
  # TODO: Fix this
  # has_many :competitions, through: :leaderboards
  has_many :predictions, dependent: :destroy
  has_many :matches, through: :predictions
  validates :name, presence: true, on: :update, if: :name_changed?

  def leaderboards(competition = nil)
    # this includes creator or leaderboard and members
    leaderboards = Leaderboard.includes(:memberships).where(memberships: { user: self }).or(Leaderboard.where(user: self))
    leaderboards = leaderboards.where(competition: competition) if competition
    leaderboards
  end

  def display_name
    name || email.split('@').first
  end

  def score(competition)
    # TODO: user predictions should be scoped by competition => prediction -> match -> group -> round -> competition
    # predictions.where(competition: competition).count(&:correct?) * 3
    cache_key = "#{cache_key_with_version}-score-#{competition.id}"
    cached_score = Rails.cache.read(cache_key)
    if run_score_query?({cached_score: cached_score, competition: competition})
      puts_query_message("score", cache_key)
      score_query_result = execute_score_query(competition)
      Rails.cache.write("#{cache_key_with_version}-score-#{competition.id}", score_query_result)
      return score_query_result
    else
      puts_cache_message("score", cache_key)
      return cached_score
    end
  end

  def possible_score(competition)
    competition.matches.where(status: 'finished').sum do |match|
      match.round.points
    end
  end

  def matches(competition: nil)
    cache_key = "#{cache_key_with_version}-matches"
    cached_matches = Rails.cache.read(cache_key)&.to_a
    if run_matches_query?(cached_matches)
      puts_query_message("matches", cache_key)
      matches_query_result = execute_matches_query(competition: competition).to_a
      Rails.cache.write("#{cache_key_with_version}-matches", matches_query_result)
      return matches_query_result
    else
      puts_cache_message("matches", cache_key)
      return cached_matches
    end
  end

  private

  def puts_cache_message(query_type, key)
    puts "using cached #{query_type} for user #{id} - cache key: #{key}"
  end

  def puts_query_message(query_type, key)
    puts "running #{query_type} query for user #{id} - cache key: #{key}"
  end

  def run_score_query?(attributes = {})
    attributes[:cached_score].nil? || score_needs_recalculating?(attributes[:competition])
  end

  # if matches have been played since the last cache was written, recalculate the score
  def score_needs_recalculating?(competition)
    expire_matches_cache?(matches(competition: competition))
  end

  # run query if cache is empty or if the next upcoming match is in the past
  def run_matches_query?(cached_result)
    cached_result.nil? || expire_matches_cache?(cached_result)
  end

  # this returns false if matches have been played since the last cache was written
  def expire_matches_cache?(cached_results_array)
    next_upcoming_match_according_to_cache = cached_results_array.select { |match| match['status'] === 'upcoming' }.map { |match| match['kickoff_time']}.sort.first
    next_upcoming_match_according_to_cache < DateTime.now
  end

  def execute_score_query(competition)
    competition.predictions.includes(match: [:round, :group]).where(user: self).sum do |prediction|
        prediction.correct? ? prediction.match.round.points : 0
    end
  end

  def execute_matches_query(competition: nil)
    query = <<-SQL.freeze
    WITH predictions AS (
      SELECT *
      FROM predictions
      WHERE user_id = :user_id OR user_id IS NULL
    ), team_badges AS (
      SELECT teams.id AS team_id, asb.key as key
      FROM teams
      INNER JOIN active_storage_attachments asat ON asat.record_id = teams.id
      JOIN active_storage_blobs asb ON asb.id = asat.blob_id
      WHERE asat.name = 'badge' AND asat.record_type = 'Team'
    ), team_flags AS (
      SELECT teams.id AS team_id, asb.key as key
      FROM teams
      INNER JOIN active_storage_attachments asat ON asat.record_id = teams.id
      JOIN active_storage_blobs asb ON asb.id = asat.blob_id
      WHERE asat.name = 'flag' AND asat.record_type = 'Team'
    ), team_with_images AS (
      SELECT teams.*, team_badges.key AS badge_key, team_flags.key AS flag_key
      FROM teams
      LEFT JOIN team_badges ON teams.id = team_badges.team_id
      LEFT JOIN team_flags ON teams.id = team_flags.team_id
    )
    SELECT
      matches.*,
      rounds.number AS round_number,
      rounds.name AS round_name,
      team_home.name AS team_home_name,
      team_home.abbrev AS team_home_abbrev,
      team_home.badge_key AS team_home_badge_key,
      team_home.flag_key AS team_home_flag_key,
      team_away.name AS team_away_name,
      team_away.abbrev AS team_away_abbrev,
      team_away.badge_key AS team_away_badge_key,
      team_away.flag_key AS team_away_flag_key,
      predictions.id AS prediction_id,
      predictions.user_id AS prediction_user_id,
      predictions.match_id AS prediction_match_id,
      CASE
        WHEN predictions.choice = 0 THEN 'home'
        WHEN predictions.choice = 1 THEN 'away'
        WHEN predictions.choice = 2 THEN 'draw'
        ELSE NULL
      END AS prediction_choice
    FROM matches
    LEFT JOIN groups ON matches.group_id = groups.id
    LEFT JOIN rounds ON matches.round_id = rounds.id OR groups.round_id = rounds.id
    JOIN team_with_images team_away ON matches.team_away_id = team_away.id
    JOIN team_with_images team_home ON matches.team_home_id = team_home.id
    LEFT JOIN predictions ON predictions.match_id = matches.id
    #{'WHERE rounds.competition_id = :competition_id' if competition}
    ORDER BY matches.kickoff_time
    SQL
    User.execute_sql(query, user_id: id, competition_id: competition&.id)
  end

end

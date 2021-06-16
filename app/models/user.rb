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

  def leaderboards(competition = nil)
    # this includes creator or leaderboard and members
    leaderboards = Leaderboard.includes(:memberships).where(memberships: { user: self }).or(Leaderboard.where(user: self))
    leaderboards = leaderboards.where(competition: competition) if competition
    leaderboards
  end

  def display_name
    name || email
  end

  def score(competition)
    # TODO: user predictions should be scoped by competition => prediction -> match -> group -> round -> competition
    # predictions.where(competition: competition).count(&:correct?) * 3
    competition.predictions.where(user: self).count(&:correct?) * 3
  end

  def matches(competition: nil)
    query = <<-SQL.freeze
    WITH predictions AS (
      SELECT *
      FROM predictions
      WHERE user_id = :user_id OR user_id IS NULL
    )
    SELECT
      matches.*,
      team_away.name, team_away.abbrev,
      team_home.name, team_home.abbrev,
      predictions.choice,
      rounds.number, rounds.name
    FROM matches
    LEFT JOIN groups ON matches.group_id = groups.id
    LEFT JOIN rounds ON matches.round_id = rounds.id OR groups.round_id = rounds.id
    JOIN teams team_away ON matches.team_away_id = team_away.id
    JOIN teams team_home ON matches.team_home_id = team_home.id
    LEFT JOIN predictions ON predictions.match_id = matches.id
    #{'WHERE rounds.competition_id = :competition_id' if competition}
    ORDER BY matches.kickoff_time
    SQL
    User.execute_sql(query, user_id: id, competition_id: competition&.id)
  end
end

class Match < ApplicationRecord
  belongs_to :competition
  belongs_to :team_away, class_name: 'Team'
  belongs_to :team_home, class_name: 'Team'
  belongs_to :group, optional: true
  belongs_to :round
  belongs_to :next_match, class_name: 'Match', optional: true
  has_many :predictions, dependent: :destroy
  has_many :users, through: :predictions
  validates :kickoff_time, presence: true
  validates :status, presence: true
  validates :api_id, uniqueness: { allow_nil: true }
  validates_uniqueness_of :kickoff_time, scope: %i[team_home team_away]
  validate :check_team_and_day_uniqueness
  enum status: { upcoming: 'upcoming', started: 'started', finished: 'finished' }, _default: :upcoming

  # Scenic views
  has_many :results, class_name: 'MatchResult'

  before_validation :set_round_and_competition, on: :create
  after_commit :refresh_materialized_views

  def check_team_and_day_uniqueness
    if Match.where(team_away: team_away, team_home: team_home).where.not(id: self).find_by("kickoff_time::date = ?", kickoff_time.to_date)
      errors.add(:kickoff_time, "isn't available on this date")
    end
  end

  def update_with_api(match_info)
    finished! if match_info['status'] == 'FINISHED'
    started! if match_info['status'] == 'IN PLAY' || match_info['status'] == 'LIVE'
    self.team_home_score = match_info['score']['fullTime']['home']
    self.team_away_score = match_info['score']['fullTime']['away']
    self.team_home_et_score = match_info['score']['extraTime']['home'] if match_info['score']['extraTime']
    self.team_away_et_score = match_info['score']['extraTime']['away'] if match_info['score']['extraTime']
    self.team_home_ps_score = match_info['score']['penalties']['home'] if match_info['score']['penalties']
    self.team_away_ps_score = match_info['score']['penalties']['away'] if match_info['score']['penalties']
    save

    scores = ["FT Score > #{build_regular_time_score}"]
    scores << "Extra-time > #{team_home_et_score} - #{team_away_et_score}" unless match_info['score']['extraTime']&.blank?
    scores << "Penalties > #{team_home_ps_score} - #{team_away_ps_score}" unless match_info['score']['penalties']&.blank?
    puts "Match Update:\n#{scores.join("\n")}"
  end

  private

  def set_round_and_competition
    self.round ||= group&.round
    self.competition ||= round&.competition
  end

  def build_regular_time_score
    if team_home_ps_score || team_away_ps_score
      "#{team_home_score - team_home_ps_score} - #{team_away_score - team_away_ps_score}"
    else
      "#{team_home_score} - #{team_away_score}"
    end
  end
end

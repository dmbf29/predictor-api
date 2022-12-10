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
    started! if match_info['status'] == 'IN PLAY'
    self.team_home_score, self.team_away_score = match_info['score']&.split(' - ')
    self.team_home_et_score, self.team_away_et_score = match_info['et_score']&.split(' - ')
    self.team_home_ps_score, self.team_away_ps_score = match_info['ps_score']&.split(' - ')
    save

    scores = ["FT Score > #{match_info['score']}"]
    scores << "Extra-time > #{match_info['et_score']}" unless match_info['et_score']&.blank?
    scores << "Penalties > #{match_info['ps_score']}" unless match_info['ps_score']&.blank?
    puts "Match Update:\n#{scores.join("\n")}"
  end

  private

  def set_round_and_competition
    self.round ||= group&.round
    self.competition ||= round&.competition
  end
end

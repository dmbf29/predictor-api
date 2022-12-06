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
  enum status: { upcoming: 'upcoming', started: 'started', finished: 'finished' }, _default: :upcoming

  # Scenic views
  has_many :results, class_name: 'MatchResult'

  before_validation :set_round_and_competition, on: :create
  after_commit :refresh_materialized_views

  private

  def set_round_and_competition
    self.round ||= group&.round
    self.competition ||= round&.competition
  end
end

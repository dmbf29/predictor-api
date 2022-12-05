class Prediction < ApplicationRecord
  belongs_to :match
  has_one :competition, through: :match
  belongs_to :user
  validates_uniqueness_of :user, scope: :match
  validates :choice, presence: true
  enum choice: { home: 'home', away: 'away', draw: 'draw' }

  scope :locked, -> { joins(:match).where.not(matches: { status: :upcoming }) }

  after_commit :refresh_materialized_views

  def correct?
    return unless match.finished?

    choice == match.winner_side
  end

  private

  def refresh_materialized_views
    UserScore.refresh
    LeaderboardRanking.refresh
  end
end

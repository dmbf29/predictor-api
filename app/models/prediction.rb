class Prediction < ApplicationRecord
  belongs_to :match
  has_one :competition, through: :match
  belongs_to :user
  validates_uniqueness_of :user, scope: :match
  validates :choice, presence: true
  enum choice: { home: 'home', away: 'away', draw: 'draw' }

  scope :editable, -> { joins(:match).where(matches: { status: :upcoming }) }
  scope :locked, -> { joins(:match).where.not(matches: { status: :upcoming }) }

  after_commit :refresh_materialized_views
end

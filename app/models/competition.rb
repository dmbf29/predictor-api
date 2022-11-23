class Competition < ApplicationRecord
  belongs_to :current_round, class_name: 'Round', optional: true
  has_many :rounds, dependent: :destroy
  has_many :groups, through: :rounds
  has_many :matches, through: :groups
  has_many :affiliations, through: :groups
  has_many :teams, through: :affiliations
  has_many :leaderboards, dependent: :destroy
  has_many :predictions, through: :matches, dependent: :destroy
  has_many :users, through: :predictions
  validates :name, presence: true, uniqueness: { scope: :start_date}
  validates :start_date, presence: true
  validates :end_date, presence: true
  scope :on_going, -> { where('start_date < :start AND end_date > :end', start: Date.today + 1, end: Date.today - 1) }

  def matches
    Match.where(group: groups).or(Match.where(round: rounds))
  end

  def predictions
    Prediction.where(match: matches)
  end
end

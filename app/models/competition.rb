class Competition < ApplicationRecord
  belongs_to :current_round, class_name: 'Round', optional: true
  has_many :matches, dependent: :destroy
  has_many :rounds, -> { distinct }, through: :matches
  has_many :groups, through: :rounds
  has_many :affiliations, through: :groups
  has_many :teams, through: :affiliations
  has_many :leaderboards, dependent: :destroy
  has_many :predictions, through: :matches, dependent: :destroy
  has_many :users, through: :leaderboards, source: :users
  has_one_attached :photo

  validates :name, presence: true, uniqueness: { scope: :start_date}
  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :on_going, -> { where('start_date < :start AND end_date > :end', start: Date.today + 1, end: Date.today - 1) }

  after_commit :refresh_materialized_views
  before_destroy :destroy_rounds

  def destroy_rounds
    Round.where(competition: self).destroy_all
  end

  def max_possible_score
    matches.finished.joins(:round).sum('rounds.points')
  end
end

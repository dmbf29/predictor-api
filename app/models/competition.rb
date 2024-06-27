class Competition < ApplicationRecord
  belongs_to :current_round, class_name: 'Round', optional: true
  has_many :matches, -> { distinct }, dependent: :destroy
  has_many :rounds, -> { distinct }, through: :matches
  has_many :groups, through: :rounds
  has_many :affiliations, through: :groups
  has_many :teams, through: :affiliations
  has_many :leaderboards, dependent: :destroy
  has_many :predictions, through: :matches, dependent: :destroy
  has_many :users, through: :leaderboards, source: :users
  # For some reason, this doesn't give me back a collection
  # has_many :all_users_predicted, -> { distinct }, through: :predictions, source: :user
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

  def users_predicted
    # For some reason, this doesn't give me back a collection
    # User.joins(:predictions)
    #     .where(predictions: { user_id: predictions.select(:user_id).distinct }).distinct
    # TODO: refactor using an Active Record query that works
    user_ids = User.find_by_sql(['SELECT DISTINCT users.id FROM users JOIN predictions ON predictions.user_id = users.id JOIN matches ON matches.id = predictions.match_id WHERE matches.competition_id = ?', id])
    User.where(id: user_ids.pluck(:id))
  end
end

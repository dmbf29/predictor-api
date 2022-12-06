class Leaderboard < ApplicationRecord
  belongs_to :user
  belongs_to :competition
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :locked_predictions, -> { locked }, through: :users, source: :predictions

  # Scenic views
  has_many :match_results, -> { distinct }
  has_many :rankings, class_name: 'LeaderboardRanking'

  validates :name, presence: true
  has_secure_token :password
  after_create :create_owner_membership
  after_commit :refresh_materialized_views

  scope :auto_join, -> { where(auto_join: true) }

  def transfer_ownership
    membership = memberships.first
    membership.destroy
    self.user = membership.user
    save
  end

  private

  def create_owner_membership
    memberships.create(user: user)
  end
end

class Membership < ApplicationRecord
  belongs_to :leaderboard
  belongs_to :user
  has_one :competition, through: :leaderboard
  validates_uniqueness_of :user, scope: :leaderboard
  after_destroy :update_leaderboard_ownership

  private

  def update_leaderboard_ownership
    return unless user == leaderboard.user
    
    leaderboard.memberships.any? ? leaderboard.transfer_ownership : leaderboard.destroy
  end
end

class Membership < ApplicationRecord
  belongs_to :leaderboard
  belongs_to :user
  has_one :competition, through: :leaderboard
  validates_uniqueness_of :user, scope: :leaderboard
  after_create :auto_join_competition_leaderboards
  after_destroy :update_leaderboard_ownership
  after_commit :refresh_materialized_views

  private

  def auto_join_competition_leaderboards
    return if leaderboard.auto_join?

    DatabaseViews.run_without_callback(then_refresh: true) do
      leaderboard.competition.leaderboards.auto_join.each do |auto_lb|
        auto_lb.memberships.find_or_create_by(user: user)
      end
    end
  end

  def update_leaderboard_ownership
    return unless user == leaderboard.user
    
    leaderboard.memberships.any? ? leaderboard.transfer_ownership : leaderboard.destroy
  end
end

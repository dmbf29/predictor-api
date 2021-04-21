class Membership < ApplicationRecord
  belongs_to :leaderboard
  belongs_to :user
  validates_uniqueness_of :user, scope: :leaderboard
end

class Membership < ApplicationRecord
  belongs_to :leaderboard
  belongs_to :user
  has_one :competition, through: :leaderboard
  validates_uniqueness_of :user, scope: :leaderboard
end

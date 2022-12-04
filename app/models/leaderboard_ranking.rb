class LeaderboardRanking < ActiveRecord::Base
  belongs_to :Leaderboard
  belongs_to :competition
  belongs_to :user
end
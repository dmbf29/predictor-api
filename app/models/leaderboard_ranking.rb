class LeaderboardRanking < ScenicViewRecord
  belongs_to :leaderboard
  belongs_to :competition
  belongs_to :user
end

class LeaderboardRanking < ScenicViewRecord
  belongs_to :leaderboard
  belongs_to :competition
  belongs_to :user

  # Scenic views
  has_many :user_scores, through: :competition
  has_many :match_results, through: :competition
end
class CreateLeaderboardRankings < ActiveRecord::Migration[6.1]
  def change
    create_view :leaderboard_rankings, materialized: true
  end
end

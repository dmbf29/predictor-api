class RefreshDatabaseViewsJob < ApplicationJob
  queue_as :default

  def perform
    # The materialized views need to be refreshed in this order
    MatchResult.refresh
    UserScore.refresh
    LeaderboardRanking.refresh
  end
end

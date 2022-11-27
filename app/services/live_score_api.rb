class LiveScoreApi
  def self.matches_future_url(competition_api_id)
    "https://livescore-api.com/api-client/fixtures/matches.json?key=#{ENV['LIVE_SCORE_KEY']}&secret=#{ENV['LIVE_SCORE_SECRET']}&competition_id=#{competition_api_id}"
  end

  def self.matches_history_url(competition_api_id)
    "http://livescore-api.com/api-client/scores/history.json?key=#{ENV['LIVE_SCORE_KEY']}&secret=#{ENV['LIVE_SCORE_SECRET']}&competition_id=#{competition_api_id}"
  end

  def self.matches_live_url(competition_api_id)
    "https://livescore-api.com/api-client/scores/live.json?key=#{ENV['LIVE_SCORE_KEY']}&secret=#{ENV['LIVE_SCORE_SECRET']}&competition_id=#{competition_api_id}"
  end
end

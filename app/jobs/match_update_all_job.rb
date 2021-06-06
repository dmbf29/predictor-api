class MatchUpdateAllJob < ApplicationJob
  queue_as :default

  def perform
    competition_id = 387
    response = HTTParty.get("http://livescore-api.com/api-client/countries/list.json?key=#{ENV['LIVE_SCORE_KEY']}&secret=#{ENV['LIVE_SCORE_SECRET']}&competition_id=#{competition_id}").body
    countries = JSON.parse(response)['data']['country']
  end
end

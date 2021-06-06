class MatchUpdateJob < ApplicationJob
  queue_as :default

  def perform
    Competition.find_each do |competition|
      response = HTTParty.get("https://livescore-api.com/api-client/fixtures/matches.json?key=#{ENV['LIVE_SCORE_KEY']}&secret=#{ENV['LIVE_SCORE_SECRET']}&competition_id=#{competition.api_id}").body
      matches = JSON.parse(response)['data']['match']
      matches.each do |match|
        p match
        puts
      end
    end
  end
end

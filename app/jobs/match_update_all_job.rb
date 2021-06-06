class MatchUpdateAllJob < ApplicationJob
  queue_as :default

  def perform
    competitions = Competition.on_going
    competitions.each do |competition|
      response = HTTParty.get("http://livescore-api.com/api-client/scores/history.json?key=#{ENV['LIVE_SCORE_KEY']}&secret=#{ENV['LIVE_SCORE_SECRET']}&competition_id=#{competition.api_id}").body
      matches = JSON.parse(response)['data']['match']
      matches.each do |match|
        p match
        puts
      end
    end
  end
end

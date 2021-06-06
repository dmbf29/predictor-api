class MatchUpdateJob < ApplicationJob
  queue_as :default

  def perform(competition_id)
    counter = 0
    competition = Competition.find(competition_id)
    url_to_update = "https://livescore-api.com/api-client/fixtures/matches.json?key=#{ENV['LIVE_SCORE_KEY']}&secret=#{ENV['LIVE_SCORE_SECRET']}&competition_id=#{competition.api_id}"
    while url_to_update
      url_to_update = update_matches(url_to_update)
      counter += 1
    end
    counter
  end

  def get_home_team(match)
    Team.find_by(name: match['home_name'])
  end

  def get_away_team(match)
    Team.find_by(name: match['away_name'])
  end

  def update_matches(url)
    response = HTTParty.get(url).body
    matches = JSON.parse(response)['data']['fixtures']
    matches.each do |match|
      match = Match.find_by(id: match['id']) || Match.find_by(team_home: get_home_team(match), team_away: get_away_team(match))
      p match
      # match.id = match['id'])
      # match.kickoff_time =
      # team_home_score = nil
      # team_away_score = nil
      # status = "upcoming"
    end
    return response['data']['next_page']
  end
end

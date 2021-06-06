class MatchUpdateJob < ApplicationJob
  queue_as :default

  def perform(competition_id)
    competition = Competition.find(competition_id)
    url_to_update = "https://livescore-api.com/api-client/fixtures/matches.json?key=#{ENV['LIVE_SCORE_KEY']}&secret=#{ENV['LIVE_SCORE_SECRET']}&competition_id=#{competition.api_id}"
    while url_to_update
      url_to_update = update_matches(url_to_update)
    end
  end

  def get_home_team(match_info)
    Team.find_by(name: match_info['home_name'])
  end

  def get_away_team(match_info)
    Team.find_by(name: match_info['away_name'])
  end

  def update_matches(url)
    response = HTTParty.get(url).body
    parsed_response = JSON.parse(response)['data']
    matches = parsed_response['fixtures']
    matches.each do |match_info|
      match = Match.find_by(id: match_info['id']) || Match.find_by(team_home: get_home_team(match_info), team_away: get_away_team(match_info))
      next unless match # knock-out rounds with no teams

      match.id = match_info['id']
      match.location = match_info['location']
      match.kickoff_time = DateTime.parse("#{match_info['date']} #{match_info['time']}")
      match.save
    end
    return parsed_response['next_page']
  end
end

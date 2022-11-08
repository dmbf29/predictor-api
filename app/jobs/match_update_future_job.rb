class MatchUpdateFutureJob < ApplicationJob
  queue_as :default

  def perform(competition_id)
    @competition = Competition.find(competition_id)
    url_to_update = LiveScoreApi.matches_future_url(@competition.api_id)
    while url_to_update
      url_to_update = update_matches_future(url_to_update)
    end
  end

  def update_matches_future(url)
    response = HTTParty.get(url).body
    parsed_response = JSON.parse(response)['data']
    matches = parsed_response['fixtures']
    matches.each do |match_info|
      kickoff_time = DateTime.parse("#{match_info['date']} #{match_info['time']}")
      puts "Finding the match between : #{match_info['home_name']} v #{match_info['away_name']} (#{kickoff_time})"
      match = @competition.matches.find_by(api_id: match_info['id']) || Match.new
      match.team_home ||= Team.find_by(api_id: match_info['home_id'])
      match.team_away ||= Team.find_by(api_id: match_info['away_id'])
      next unless match.team_home && match.team_away # knock-out rounds with no teams yet

      # Only adding a round for knockout stages, group isn't provided by API :/
      match.round = @competition.rounds.find_by(api_name: match_info['round']) unless match_info['round'] == '3'
      match.api_id = match_info['id']
      match.location = match_info['location']
      match.kickoff_time = kickoff_time
      match.save
      puts 'Match Update'
    end
    return parsed_response['next_page']
  end
end

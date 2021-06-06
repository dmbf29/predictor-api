class MatchUpdateHistoryJob < ApplicationJob
  queue_as :default

  def perform(competition_id)
    competition = Competition.find(competition_id)
    url_to_update = LiveScoreApi.matches_history_url(competition.api_id)
    while url_to_update
      url_to_update = update_matches_history(url_to_update)
    end
  end

  def get_team(id)
    Team.find_by(api_id: id)
  end

  def update_matches_history(url)
    response = HTTParty.get(url).body
    parsed_response = JSON.parse(response)['data']
    matches = parsed_response['match']
    matches.each do |match_info|
      kickoff_time = DateTime.parse("#{match_info['date']} #{match_info['time']}")
      puts "Finding the match between : #{match_info['home_name']} v #{match_info['away_name']} (#{kickoff_time})"
      match = Match.find_by(api_id: match_info['id']) || Match.find_by(team_home: get_team(match_info['home_id']), team_away: get_team(match_info['away_id']), kickoff_time: kickoff_time)
      next unless match # knock-out rounds with no teams

      match.finished!
      p scores = match_info['score'].split(' - ')
      match.team_home_score = scores.first
      match.team_away_score = scores.second
      match.save
      puts 'Match Update'
    end
    return parsed_response['next_page']
  end
end

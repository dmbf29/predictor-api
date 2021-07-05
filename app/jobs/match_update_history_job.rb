class MatchUpdateHistoryJob < ApplicationJob
  queue_as :default

  def perform(competition_id)
    competition = Competition.find(competition_id)
    url_to_update = LiveScoreApi.matches_history_url(competition.api_id)
    while url_to_update
      url_to_update = update_matches_history(url_to_update, competition)
    end
  end

  def get_team(id)
    Team.find_by(api_id: id)
  end

  def update_matches_history(url, competition)
    response = HTTParty.get(url).body
    parsed_response = JSON.parse(response)['data']
    matches = parsed_response['match']
    matches.each do |match_info|
      kickoff_time = DateTime.parse("#{match_info['date']} #{match_info['scheduled']}")
      puts "Finding the match between : #{match_info['home_name']} v #{match_info['away_name']} (#{kickoff_time})"
      match = competition.matches.find_by(api_id: match_info['fixture_id']) || competition.matches.find_by(team_home: get_team(match_info['home_id']), team_away: get_team(match_info['away_id']), kickoff_time: kickoff_time)
      next unless match

      match.finished!
      match.team_home_score, match.team_away_score = match_info['score']&.split(' - ')
      match.team_home_et_score, match.team_away_et_score = match_info['et_score']&.split(' - ')
      match.team_home_ps_score, match.team_away_ps_score = match_info['ps_score']&.split(' - ')
      match.save

      scores = ["FT Score > #{match_info['score']}"]
      scores << "Extra-time > #{match_info['et_score']}" unless match_info['et_score'].blank?
      scores << "Penalties > #{match_info['ps_score']}" unless match_info['ps_score'].blank?
      puts "Match Update:\n#{scores.join("\n")}"
    end
    return parsed_response['next_page']
  end
end

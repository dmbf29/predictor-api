class MatchUpdateLiveJob < ApplicationJob
  queue_as :default

  def perform(competition_id)
    competition = Competition.find(competition_id)
    url_to_update = LiveScoreApi.matches_live_url(competition.api_id)
    update_matches_live(url_to_update, competition)
  end

  def get_team(id)
    Team.find_by(api_id: id)
  end

  def update_matches_live(url, competition)
    # To test it locally, switch out the response:
    # response = File.open('db/live_score_example.json').read
    response = HTTParty.get(url).body
    parsed_response = JSON.parse(response)['data']
    matches = parsed_response['match']
    matches.each do |match_info|
      kickoff_time = DateTime.parse("#{match_info['date']} #{match_info['scheduled']}")
      puts "Finding the match between : #{match_info['home_name']} v #{match_info['away_name']} (#{kickoff_time})"
      match = competition.matches.find_by(api_id: match_info['fixture_id']) || competition.matches.find_by(team_home: get_team(match_info['home_id']), team_away: get_team(match_info['away_id']), kickoff_time: kickoff_time)
      next unless match

      match.update_with_api(match_info)
    end
  end
end

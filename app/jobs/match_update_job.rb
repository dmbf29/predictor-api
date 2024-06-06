class MatchUpdateJob < ApplicationJob
  queue_as :default

  def perform(competition_id)
    @competition = Competition.find(competition_id)
    url_to_update = DataFootballApi.matches_url(@competition.api_code)
    update_matches_future(url_to_update)
  end

  def update_matches_future(url)
    response = HTTParty.get(
      url,
      headers: {
        'Content-Type' => 'application/json',
        'X-Auth-Token' => ENV['FOOTBALL_DATA_TOKEN']
      }
    ).body
    parsed_response = JSON.parse(response)
    matches = parsed_response['matches']
    DatabaseViews.run_without_callback(then_refresh: true) do
      matches.each do |match_info|
        kickoff_time = DateTime.parse(match_info['utcDate'])
        puts "Finding the match between : #{match_info['homeTeam']['name']} v #{match_info['awayTeam']['name']} (#{kickoff_time})"
        team_home = Team.find_by(abbrev: match_info['homeTeam']['tla'])
        team_away = Team.find_by(abbrev: match_info['awayTeam']['tla'])
        match =
        @competition.matches.where(team_home: team_home, team_away: team_away)
        .find_by(kickoff_time: kickoff_time) || Match.new
        match.team_home ||= team_home
        match.team_away ||= team_away
        next unless match.team_home && match.team_away # knock-out rounds with no teams yet

        match.round = Round.find_by(competition: @competition, api_name: match_info['stage'])
        match.group = Group.find_by(round: match.round, api_code: match_info["group"]) if match_info["group"]
        match.api_id = match_info['id']
        # TODO: Don't think we're getting the location from the API
        # match.location = match_info['location']
        match.kickoff_time = kickoff_time
        match.save
        p match.errors.full_messages if match.errors.any?

        # Update scores
        match.update_with_api(match_info)
        puts 'Match Update'
      end
    end
  end
end

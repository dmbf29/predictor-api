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
    if matches.nil?
      Rails.logger.error("MatchUpdateJob: unexpected API response — #{parsed_response.inspect}")
      return
    end
    DatabaseViews.run_without_callback(then_refresh: true) do
      matches.each do |match_info|
        kickoff_time = DateTime.parse(match_info['utcDate'])
        puts "Finding the match between : #{match_info['homeTeam']['name']} v #{match_info['awayTeam']['name']} (#{kickoff_time})"
        team_home = Team.find_by(abbrev: match_info['homeTeam']['tla'])
        team_away = Team.find_by(abbrev: match_info['awayTeam']['tla'])

        match = @competition.matches.find_by(api_id: match_info['id']) ||
                (team_home && team_away &&
                  @competition.matches.where(team_home: team_home, team_away: team_away)
                              .find_by(kickoff_time: kickoff_time)) ||
                Match.new

        match.team_home ||= team_home
        match.team_away ||= team_away
        next if match_info['stage'] == 'THIRD_PLACE' # skip 3rd place game

        match.round = Round.find_by(competition: @competition, api_name: match_info['stage'])
        next unless match.round # can't persist without a round

        match.group = Group.find_by(round: match.round, api_code: match_info["group"]) if match_info["group"]
        match.api_id = match_info['id']
        match.location = match_info['venue']
        match.minute = match_info['minute']
        match.matchday = match_info['matchday']
        match.kickoff_time = kickoff_time
        match.save
        p match.errors.full_messages if match.errors.any?

        # Only update scores once teams are confirmed
        match.update_with_api(match_info) if match.team_home && match.team_away
        puts 'Match Update'
      end
    end
  end
end

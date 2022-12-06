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
    DatabaseViews.run_without_callback(then_refresh: true) do
      matches.each do |match_info|
        kickoff_time = DateTime.parse("#{match_info['date']} #{match_info['time']}")
        puts "Finding the match between : #{match_info['home_name']} v #{match_info['away_name']} (#{kickoff_time})"
        match = @competition.matches.find_by(api_id: match_info['id']) || Match.new
        match.team_home ||= Team.find_by(api_id: match_info['home_id'])
        match.team_away ||= Team.find_by(api_id: match_info['away_id'])
        next unless match.team_home && match.team_away # knock-out rounds with no teams yet

        # Only adding a round for knockout stages, group isn't provided by API :/
        if %w[1 2 3].include?(match_info['round'])
          match.group = @competition.groups.find_by(api_id: match_info["group_id"])
        else
          match.round = @competition.rounds.find_by(api_name: match_info['round'])
        end
        match.api_id = match_info['id']
        match.location = match_info['location']
        match.kickoff_time = kickoff_time
        match.save
        p match.errors.full_messages if match.errors.any?
        puts 'Match Update'
      end
    end
    return parsed_response['next_page']
  end
end

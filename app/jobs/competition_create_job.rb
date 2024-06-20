class CompetitionCreateJob < ApplicationJob
  queue_as :default

  def perform(competition_code)
    url = DataFootballApi.teams_url(competition_code)
    response = HTTParty.get(
      url,
      headers: {
        'Content-Type' => 'application/json',
        'X-Auth-Token' => ENV['FOOTBALL_DATA_TOKEN']
      }
    ).body
    parsed_response = JSON.parse(response)
    competition_parsed = parsed_response['competition']
    season_parsed = parsed_response['season']
    puts 'Creating the competition...'
    competition = Competition.find_or_create_by!(name: "#{competition_parsed['name']} #{Date.today.year}", start_date: Date.parse(season_parsed["startDate"]), end_date: Date.parse(season_parsed["endDate"]), api_id: competition_parsed['id'], api_code: competition_parsed['code'])
    puts '.. created the competition'

    puts 'Creating or finding the rounds...'
    season_parsed['stages'].each_with_index do |stage_key, index|
      round = Round.find_or_create_by!(name: stage_key.titleize, number: index + 1, competition: competition, api_name: stage_key)
      competition.update!(current_round: round) if index.zero?
    end

    url = DataFootballApi.matches_url(competition_code)
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
        next unless match_info['homeTeam']['tla'] && match_info['awayTeam']['tla'] # knock-out rounds with no teams yet

        team_home = Team.find_by(abbrev: match_info['homeTeam']['tla']) || Team.create!(name: match_info['homeTeam']['shortName'], abbrev: match_info['homeTeam']['tla'])
        team_away = Team.find_by(abbrev: match_info['awayTeam']['tla']) || Team.create!(name: match_info['awayTeam']['shortName'], abbrev: match_info['awayTeam']['tla'])

        puts 'Getting/creating round and group...'
        round = Round.find_by!(competition: competition, api_name: match_info['stage'])
        group = Group.find_or_create_by!(name: match_info['group'].titleize, round: round, api_code: match_info['group'])

        puts "Adding #{team_home.abbrev} and #{team_away.abbrev} to #{group.name}"
        Affiliation.find_or_create_by!(team: team_home, group: group)
        Affiliation.find_or_create_by!(team: team_away, group: group)

        match =
        competition.matches.where(team_home: team_home, team_away: team_away)
        .find_by(kickoff_time: kickoff_time) || Match.new
        match.team_home ||= team_home
        match.team_away ||= team_away
        match.round = round
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

      leaderboard_hash = {
        name: 'Global Top Players',
        description: 'The top players on Octacle',
        rankings_top_n: 10,
        leave_disabled: true,
        auto_join: true,
      }
      admin = User.find_by(admin: true)
      leaderboard = competition.leaderboards.find_or_initialize_by(leaderboard_hash.slice(:name))
      leaderboard.assign_attributes(leaderboard_hash)
      leaderboard.user ||= admin
      leaderboard.save!

      puts "-----> Creating memberships for #{leaderboard.name} (#{leaderboard.competition.name})"
      User.find_each { |user| leaderboard.memberships.find_or_create_by!(user: user) }
      AttachFlagsJob.perform_later(competition.id)
    end


  end
end

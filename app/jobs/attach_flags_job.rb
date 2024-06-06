class AttachFlagsJob < ApplicationJob
  queue_as :default

  def perform(competition_id)
    competition = Competition.find(competition_id)
    url = DataFootballApi.teams_url(competition.api_code)
    response = HTTParty.get(
      url,
      headers: {
        'Content-Type' => 'application/json',
        'X-Auth-Token' => ENV['FOOTBALL_DATA_TOKEN']
      }
    ).body
    teams = JSON.parse(response)['teams']
    teams.each do |team_hash|
      team = Team.find_by(abbrev: team_hash['tla'])
      puts "#{team.name}: #{team_hash['crest']}"
      team.flag.attach(io: URI.open(team_hash['crest']), filename: 'flag.png', content_type: 'image/png') unless team.flag.attached?
      team.badge.attach(io: URI.open(team_hash['crest']), filename: 'badge.png', content_type: 'image/png') unless team.badge.attached?
      puts team.flag.attached? ? 'Success' : 'Failed'
    end
  end
end

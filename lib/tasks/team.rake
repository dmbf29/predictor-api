namespace :team do
  desc "Calls Live-Score API, saves API id and gets the flag"
  task add_flag: :environment do
    competition_id = 362
    season = 2022
    response = HTTParty.get("https://livescore-api.com/api-client/competitions/participants.json?key=#{ENV['LIVE_SCORE_KEY']}&secret=#{ENV['LIVE_SCORE_SECRET']}&competition_id=#{competition_id}&season=#{season}").body
    countries = JSON.parse(response)['data']

    not_found = []
    competition = Competition.find_by(api_id: competition_id)
    competition.teams.find_each do |team|
      country = countries.find { |country| country['name'] == team.name }
      if country
        team.api_id = country['id']
        team.save
        next if team.flag.attached? && team.badge.attached?

        fetch_flag(team)
      else
        not_found << team.name
      end
    end

    puts not_found.any? ? "Teams not found: #{not_found.join(', ')}" : 'Found all teams'
  end

  def fetch_flag(team)
    url = "https://livescore-api.com/api-client/countries/flag.json?key=#{ENV['LIVE_SCORE_KEY']}&secret=#{ENV['LIVE_SCORE_SECRET']}&team_id=#{team.api_id}"
    puts "#{team.name}: #{url}"
    file = URI.open(url)
    team.flag.attach(io: file, filename: 'flag.png', content_type: 'image/png') unless team.flag.attached?
    team.badge.attach(io: file, filename: 'badge.png', content_type: 'image/png') unless team.badge.attached?
    puts team.flag.attached? ? 'Success' : 'Failed'
  end

  desc "Changes North Macedonia to FYR Macedonia"
  task update_macedonia: :environment do
    team = Team.find_by(name: 'North Macedonia')
    team.name = 'FYR Macedonia' if team
    team.save
  end
end

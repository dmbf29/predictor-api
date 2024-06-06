namespace :team do
  desc "Calls Data-Football API and gets the flags"
  task add_flag: :environment do
    Competition.find_each do |competition|
      AttachFlagsJob.perform_now(competition.id)
    end
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

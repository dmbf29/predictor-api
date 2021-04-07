require 'open-uri'

puts 'Getting Admin users...'
doug = User.find_by(email: 'douglasmberkley@gmail.com') || User.create(email: 'douglasmberkley@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
trouni = User.find_by(email: 'trouni@gmail.com') || User.create(email: 'trouni@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
james = User.find_by(email: 'devereuxjj@gmail.com') || User.create(email: 'devereuxjj@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)

puts 'Creating test users...'
20.times do
  User.create(
    # fake emails for testing purposes
    email: Faker::Internet.safe_email,
    password: '123123'
  )
end
puts "... #{User.count} Total Users"

groups = {
  'Group A' => [
    { name: 'Italy', abbrev: 'ITA' },
    { name: 'Switzerland', abbrev: 'SUI' },
    { name: 'Turkey', abbrev: 'TUR' },
    { name: 'Wales', abbrev: 'WAL' }
  ],
  'Group B' => [
    { name: 'Belgium', abbrev: 'BEL' },
    { name: 'Denmark', abbrev: 'DEN' },
    { name: 'Finland', abbrev: 'FIN' },
    { name: 'Russia', abbrev: 'RUS' }
  ],
  'Group C' => [
    { name: 'Austria', abbrev: 'AUT' },
    { name: 'Netherlands', abbrev: 'NED' },
    { name: 'North Macedonia', abbrev: 'MKD' },
    { name: 'Ukraine', abbrev: 'UKR' }
  ],
  'Group D' => [
    { name: 'Croatia', abbrev: 'CRO' },
    { name: 'Czech Republic', abbrev: 'CZE' },
    { name: 'England', abbrev: 'ENG' },
    { name: 'Scotland', abbrev: 'SCO' }
  ],
  'Group E' => [
    { name: 'Poland', abbrev: 'POL' },
    { name: 'Slovakia', abbrev: 'SVK' },
    { name: 'Spain', abbrev: 'ESP' },
    { name: 'Sweden', abbrev: 'SWE' }
  ],
  'Group F' => [
    { name: 'France', abbrev: 'FRA' },
    { name: 'Germany', abbrev: 'GER' },
    { name: 'Hungary', abbrev: 'HUN' },
    { name: 'Portugal', abbrev: 'POR' }
  ]
}

puts 'Creating the Euros...'
euros = Competition.find_or_create_by!(name: 'Euro 2020', start_date: Date.new(2021, 6, 12), end_date: Date.new(2021, 7, 12))
puts '.. created the Euros'

puts 'Creating or finding first round...'
first_round = Round.find_or_create_by!(name: 'Group Stage', number: 1, competition: euros)
puts "...#{Round.count} Total Rounds"

puts 'Creating or finding groups...'
groups.each_key do |group_name|
  puts "...#{group_name}..."
  group = Group.find_or_create_by!(name: group_name, round: first_round)
  groups[group_name].each do |team_hash|
    puts "Name: #{team_hash[:name]}, Abbrev: #{team_hash[:abbrev]}"
    team = Team.find_or_create_by!(team_hash)
    Affiliation.find_or_create_by!(team: team, group: group)
  end
end
puts "...#{Team.count} Total Teams"
puts "...#{Group.count} Total Groups"

Team.find_each do |team|
  next if team.badge.attached?

  url = "https://www.uefa.com/imgml/flags/140x140/#{team.abbrev}.png?imwidth=2048%202048w"
  puts "#{team.name}: #{url}"
  file = URI.open(url)
  team.badge.attach(io: file, filename: 'badge.png', content_type: 'image/png')
  puts team.badge.attached? ? 'Success' : 'Failed'
end

puts 'Creating a test league w/ James as creator'
league = League.find_or_create_by!(
  name: 'Admin League',
  competition: euros,
  user: james
)

puts 'Adding Trouni and Doug to the league'
[trouni, doug].each do |user|
  Membership.find_or_create_by!(league: league, user: user)
end

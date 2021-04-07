require 'open-uri'

groups = {
  'Group A' => [
    { name: 'Italy', abbrev: 'ITA' },
    { name: 'Switzerland  ', abbrev: 'SUI' },
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
    { name: 'Germany  ', abbrev: 'GER' },
    { name: 'Hungary', abbrev: 'HUN' },
    { name: 'Portugal', abbrev: 'POR' }
  ]
}

puts 'Creating the Euros...'
competition = Competition.find_or_create_by(name: 'Euro 2020', start_date: Date.new(2021, 6, 12), end_date: Date.new(2021, 7, 12))
p competition.errors.full_messages if competition.errors.any?
puts '.. created the Euros'

puts 'Creating or finding first round...'
first_round = Round.find_or_create_by(name: 'Group Stage', number: 1, competition: competition)
p first_round.errors.full_messages if first_round.errors.any?
puts "...#{Round.count} Total Rounds"

puts 'Creating or finding groups...'
groups.each_key do |group_name|
  puts "...#{group_name}..."
  group = Group.find_or_create_by(name: group_name, round: first_round)
  p group.errors.full_messages if group.errors.any?
  groups[group_name].each do |team_hash|
    puts "Name: #{team_hash[:name]}, Abbrev: #{team_hash[:abbrev]}"
    team = Team.find_or_create_by(team_hash)
    p team.errors.full_messages if team.errors.any?
  end
end
puts "...#{Team.count} Total Teams"
puts "...#{Group.count} Total Groups"

Team.find_each do |team|
  next if unless team.badge.attached?

  url = "https://www.uefa.com/imgml/flags/70x70/#{team.abbrev}.png?imwidth=2048%202048w"
  puts "#{team.name}: #{url}"
  file = URI.open(url)
  team.badge.attach(id: file, filename: 'badge.png', content_type: 'image/png')
  puts team.badge.attached? ? 'Success' : 'Failed'
end

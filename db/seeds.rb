# url = "https://www.uefa.com/imgml/flags/70x70/CZE.png?imwidth=2048%202048w"
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
    { name: 'Slovakia   ', abbrev: 'SVK' },
    { name: 'Spain', abbrev: 'TUR' },
    { name: 'Sweden', abbrev: 'WAL' }
  ],
  'Group F' => [
    { name: 'France', abbrev: 'FRA' },
    { name: 'Germany  ', abbrev: 'GER' },
    { name: 'Hungary', abbrev: 'HUN' },
    { name: 'Portugal', abbrev: 'POR' }
  ]
}
puts 'Creating or finding first round...'
first_round = Round.find_or_create_by(name: 'Group Stage', round: 1)
puts "...#{Round.count} Total Rounds"

puts 'Creating or finding groups...'
Group.find_or_create_by(name: groups.keys, round: first_round)
puts "...#{Group.count} Total Groups"

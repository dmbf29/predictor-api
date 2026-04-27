require 'open-uri'

DatabaseViews.deactivate_callback

Leaderboard.destroy_all

puts 'Getting Admin users...'
doug = User.find_by(email: 'douglasmberkley@gmail.com') || User.create(email: 'douglasmberkley@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
trouni = User.find_by(email: 'trouni@gmail.com') || User.create(email: 'trouni@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
james = User.find_by(email: 'devereuxjj@gmail.com') || User.create(email: 'devereuxjj@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
caio = User.find_by(email: 'caio.santos@msn.com') || User.create(email: 'caio.santos@msn.com', password: ENV['ADMIN_PASSWORD'], admin: true)
renato = User.find_by(email: 'renatonato_jr@hotmail.com') || User.create(email: 'renatonato_jr@hotmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)

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
    { name: 'Mexico', abbrev: 'MEX', api_id: 769 },
    { name: 'South Africa', abbrev: 'RSA', api_id: 774 },
    { name: 'South Korea', abbrev: 'KOR', api_id: 772 },
    { name: 'Czechia', abbrev: 'CZE', api_id: 798 }
  ],
  'Group B' => [
    { name: 'Canada', abbrev: 'CAN', api_id: 828 },
    { name: 'Bosnia-Herzegovina', abbrev: 'BIH', api_id: 1060 },
    { name: 'Qatar', abbrev: 'QAT', api_id: 8030 },
    { name: 'Switzerland', abbrev: 'SUI', api_id: 788 }
  ],
  'Group C' => [
    { name: 'Brazil', abbrev: 'BRA', api_id: 764 },
    { name: 'Morocco', abbrev: 'MAR', api_id: 815 },
    { name: 'Haiti', abbrev: 'HAI', api_id: 836 },
    { name: 'Scotland', abbrev: 'SCO', api_id: 8873 }
  ],
  'Group D' => [
    { name: 'United States', abbrev: 'USA', api_id: 771 },
    { name: 'Paraguay', abbrev: 'PAR', api_id: 761 },
    { name: 'Australia', abbrev: 'AUS', api_id: 779 },
    { name: 'Turkey', abbrev: 'TUR', api_id: 803 }
  ],
  'Group E' => [
    { name: 'Germany', abbrev: 'GER', api_id: 759 },
    { name: 'Curaçao', abbrev: 'CUR', api_id: 9460 },
    { name: 'Ivory Coast', abbrev: 'CIV', api_id: 1935 },
    { name: 'Ecuador', abbrev: 'ECU', api_id: 791 }
  ],
  'Group F' => [
    { name: 'Netherlands', abbrev: 'NED', api_id: 8601 },
    { name: 'Japan', abbrev: 'JPN', api_id: 766 },
    { name: 'Sweden', abbrev: 'SWE', api_id: 792 },
    { name: 'Tunisia', abbrev: 'TUN', api_id: 802 }
  ],
  'Group G' => [
    { name: 'Belgium', abbrev: 'BEL', api_id: 805 },
    { name: 'Egypt', abbrev: 'EGY', api_id: 825 },
    { name: 'Iran', abbrev: 'IRN', api_id: 840 },
    { name: 'New Zealand', abbrev: 'NZL', api_id: 783 }
  ],
  'Group H' => [
    { name: 'Spain', abbrev: 'ESP', api_id: 760 },
    { name: 'Cape Verde Islands', abbrev: 'CPV', api_id: 1930 },
    { name: 'Saudi Arabia', abbrev: 'KSA', api_id: 801 },
    { name: 'Uruguay', abbrev: 'URU', api_id: 758 }
  ],
  'Group I' => [
    { name: 'Iraq', abbrev: 'IRQ', api_id: 8062 },
    { name: 'France', abbrev: 'FRA', api_id: 773 },
    { name: 'Senegal', abbrev: 'SEN', api_id: 804 },
    { name: 'Norway', abbrev: 'NOR', api_id: 8872 }
  ],
  'Group J' => [
    { name: 'Argentina', abbrev: 'ARG', api_id: 762 },
    { name: 'Algeria', abbrev: 'ALG', api_id: 778 },
    { name: 'Austria', abbrev: 'AUT', api_id: 816 },
    { name: 'Jordan', abbrev: 'JOR', api_id: 8049 }
  ],
  'Group K' => [
    { name: 'Congo DR', abbrev: 'COD', api_id: 1934 },
    { name: 'Portugal', abbrev: 'POR', api_id: 765 },
    { name: 'Uzbekistan', abbrev: 'UZB', api_id: 8070 },
    { name: 'Colombia', abbrev: 'COL', api_id: 818 }
  ],
  'Group L' => [
    { name: 'England', abbrev: 'ENG', api_id: 770 },
    { name: 'Croatia', abbrev: 'CRO', api_id: 799 },
    { name: 'Ghana', abbrev: 'GHA', api_id: 763 },
    { name: 'Panama', abbrev: 'PAN', api_id: 1836 }
  ]
}

crest_urls = {
  769 => 'https://crests.football-data.org/769.svg',
  774 => 'https://crests.football-data.org/9396.svg',
  772 => 'https://crests.football-data.org/772.png',
  798 => 'https://crests.football-data.org/798.svg',
  828 => 'https://crests.football-data.org/canada.svg',
  1060 => 'https://crests.football-data.org/bosnia.svg',
  8030 => 'https://crests.football-data.org/8030.svg',
  788 => 'https://crests.football-data.org/788.svg',
  764 => 'https://crests.football-data.org/764.svg',
  815 => 'https://crests.football-data.org/morocco.svg',
  836 => 'https://crests.football-data.org/haiti.svg',
  8873 => 'https://crests.football-data.org/814.svg',
  771 => 'https://crests.football-data.org/usa.svg',
  761 => 'https://crests.football-data.org/761.svg',
  779 => 'https://crests.football-data.org/779.svg',
  803 => 'https://crests.football-data.org/803.svg',
  759 => 'https://crests.football-data.org/759.svg',
  9460 => 'https://crests.football-data.org/curacao.svg',
  1935 => 'https://crests.football-data.org/787.svg',
  791 => 'https://crests.football-data.org/791.svg',
  8601 => 'https://crests.football-data.org/8601.svg',
  766 => 'https://crests.football-data.org/766.svg',
  792 => 'https://crests.football-data.org/792.svg',
  802 => 'https://crests.football-data.org/tunisia.svg',
  805 => 'https://crests.football-data.org/805.svg',
  825 => 'https://crests.football-data.org/825.svg',
  840 => 'https://crests.football-data.org/iran.svg',
  783 => 'https://crests.football-data.org/783.svg',
  760 => 'https://crests.football-data.org/760.svg',
  1930 => 'https://crests.football-data.org/cape_verde.svg',
  801 => 'https://crests.football-data.org/saudi_arabia.svg',
  758 => 'https://crests.football-data.org/758.svg',
  773 => 'https://crests.football-data.org/773.svg',
  804 => 'https://crests.football-data.org/senegal.svg',
  8062 => 'https://crests.football-data.org/iraq.svg',
  8872 => 'https://crests.football-data.org/813.svg',
  762 => 'https://crests.football-data.org/762.png',
  778 => 'https://crests.football-data.org/algeria.svg',
  816 => 'https://crests.football-data.org/816.svg',
  8049 => 'https://crests.football-data.org/8049.png',
  1934 => 'https://crests.football-data.org/congo_dr.svg',
  765 => 'https://crests.football-data.org/765.svg',
  8070 => 'https://crests.football-data.org/8070.png',
  818 => 'https://crests.football-data.org/818.svg',
  770 => 'https://crests.football-data.org/770.svg',
  799 => 'https://crests.football-data.org/799.svg',
  763 => 'https://crests.football-data.org/ghana.svg',
  1836 => 'https://crests.football-data.org/panama.svg'
}

puts 'Creating the World Cup...'
world_cup = Competition.find_or_create_by!(name: 'FIFA World Cup', start_date: Date.new(2026, 6, 11), end_date: Date.new(2026, 7, 19)) do |c|
  c.api_id = 2000
  c.api_code = 'WC'
end
puts '.. created the World Cup'

puts 'Creating or finding first round...'
first_round = Round.find_or_create_by!(name: 'Group Stage', number: 1, competition: world_cup, api_name: 'GROUP_STAGE')
puts "...#{Round.count} Total Rounds"

puts 'Creating or finding groups...'
groups.each_key do |group_name|
  puts "...#{group_name}..."
  group = Group.find_or_create_by!(name: group_name, round: first_round)
  groups[group_name].each do |team_hash|
    puts "Name: #{team_hash[:name]}, Abbrev: #{team_hash[:abbrev]}"
    team = Team.find_by(abbrev: team_hash[:abbrev]) || Team.find_or_create_by!(abbrev: team_hash[:abbrev], name: team_hash[:name])
    # Some country names change over time
    team.update!(api_id: team_hash[:api_id], name: team_hash[:name])
    Affiliation.find_or_create_by!(team: team, group: group)
  end
end
puts "...#{Team.count} Total Teams"
puts "...#{Group.count} Total Groups"

Team.find_each do |team|
  next if team.badge.attached?
  next unless (url = crest_urls[team.api_id])

  puts "#{team.name}: #{url}"
  file = URI.open(url)
  ext = File.extname(url).delete('.')
  content_type = ext == 'png' ? 'image/png' : 'image/svg+xml'
  team.badge.attach(io: file, filename: "badge.#{ext}", content_type: content_type)
  puts team.badge.attached? ? 'Success' : 'Failed'
end

puts 'Creating a test leaderboard w/ Renato as creator'
Leaderboard.find_or_create_by!(
  name: 'Admin Leaderboard',
  competition: world_cup,
  user: renato
)

puts 'Creating test users...'
5.times do
  Leaderboard.create!(
    name: Faker::Sports::Football.team,
    competition: world_cup,
    user: trouni
  )
end
puts "... #{User.count} Total Users"

puts 'Adding Users to the leaderboard'
Leaderboard.find_each do |ldbrd|
  ([doug] + User.last(20)).each do |user|
    Membership.find_or_create_by!(leaderboard: ldbrd, user: user)
  end
end

# I'm not sure why we were scraping instead of calling the API...
# ScrapeMatchesService.new.call
# Creating matches with API:
MatchUpdateJob.perform_later(world_cup.id)

# puts 'Assigning random scores to matches before June 22nd'
# Match.where('kickoff_time < ?', Date.new(2021, 6, 22)).each do |match|
#   match.update(team_away_score: rand(4), team_home_score: rand(4), status: :finished)
# end
# # Needed when migrating status enum from integer to string:
# Match.where('kickoff_time >= ?', Date.new(2021, 6, 22)).update(status: :upcoming)
# puts "...#{Match.finished.count} Finished Matches and #{Match.upcoming.count} Upcoming Matches"

DatabaseViews.activate_callback(then_refresh: true)

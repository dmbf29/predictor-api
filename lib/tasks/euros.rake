namespace :euros do
  desc "Create the UEFA Euros competition"
  task create: :environment do
    groups = {
      'Group A' => {
        api_id: nil,
        teams: [
          { name: 'Germany', abbrev: 'GER' },
          { name: 'Scotland', abbrev: 'SCO' },
          { name: 'Switzerland', abbrev: 'SUI' },
          { name: 'Hungary', abbrev: 'HUN' }
        ]
      },
      'Group B' => {
        api_id: nil,
        teams: [
          { name: 'Albania', abbrev: 'ALB' },
          { name: 'Italy', abbrev: 'ITA' },
          { name: 'Croatia', abbrev: 'CRO' },
          { name: 'Spain', abbrev: 'ESP' }
        ]
      },
      'Group C' => {
        api_id: nil,
        teams: [
          { name: 'Denmark', abbrev: 'DEN' },
          { name: 'England', abbrev: 'ENG' },
          { name: 'Serbia', abbrev: 'SRB' },
          { name: 'Slovenia', abbrev: 'SVN' }
        ]
      },
      'Group D' => {
        api_id: nil,
        teams: [
          { name: 'France', abbrev: 'FRA' },
          { name: 'Netherlands', abbrev: 'NED' },
          { name: 'Austria', abbrev: 'AUT' },
          { name: 'Poland', abbrev: 'POL' }
        ]
      },
      'Group E' => {
        api_id: nil,
        teams: [
          { name: 'Belgium', abbrev: 'BEL' },
          { name: 'Romania', abbrev: 'ROU' },
          { name: 'Slovakia', abbrev: 'SVK' },
          { name: 'Ukraine', abbrev: 'UKR' }
        ]
      },
      'Group F' => {
        api_id: nil,
        teams: [
          { name: 'Georgia', abbrev: 'GEO' },
          { name: 'Portugal', abbrev: 'POR' },
          { name: 'Czechia', abbrev: 'CZE' },
          { name: 'Turkey', abbrev: 'TUR' }
        ]
      },
    }
    puts 'Creating the Euros...'
    euros = Competition.find_or_create_by(name: 'Euros 2024', start_date: Date.new(2024, 06, 14), end_date: Date.new(2024, 07, 14), api_id: 2018, api_code: 'EC')
    puts '.. created the Euros'

    puts 'Creating or finding first round...'
    first_round = Round.find_or_create_by(name: 'Group Stage', number: 1, competition: euros, api_name: 'GROUP_STAGE')
    puts "...#{euros.rounds.count} Total Rounds"

    puts 'Creating or finding groups...'
    groups.each_key do |group_name|
      puts "...#{group_name}..."
      group = Group.find_or_create_by!(name: group_name, round: first_round, api_id: groups[group_name][:api_id])
      groups[group_name][:teams].each do |team_hash|
        puts "Name: #{team_hash[:name]}, Abbrev: #{team_hash[:abbrev]}"
        team = Team.find_or_create_by(team_hash)
        Affiliation.find_or_create_by(team: team, group: group)
      end
    end
    puts "...#{euros.teams.count} Total Teams"
    puts "...#{euros.groups.count} Total Groups"

    doug = User.find_by(email: 'douglasmberkley@gmail.com') || User.create(email: 'douglasmberkley@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
    trouni = User.find_by(email: 'trouni@gmail.com') || User.create(email: 'trouni@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
    james = User.find_by(email: 'devereuxjj@gmail.com') || User.create(email: 'devereuxjj@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
    renato = User.find_by(email: 'renatonato_jr@hotmail.com') || User.create(email: 'renatonato_jr@hotmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
    caio = User.find_by(email: 'caio.santos@msn.com') || User.create(email: 'caio.santos@msn.com', password: ENV['ADMIN_PASSWORD'], admin: true)

    puts 'Creating a test leaderboards'
    leaderboard = Leaderboard.find_or_create_by(
      name: 'Admin Leaderboard 1',
      competition: euros,
      user: trouni
    )
    Membership.find_or_create_by(leaderboard: leaderboard, user: doug)
    Membership.find_or_create_by(leaderboard: leaderboard, user: james)
    Membership.find_or_create_by(leaderboard: leaderboard, user: renato)
    Membership.find_or_create_by(leaderboard: leaderboard, user: caio)

    leaderboard = Leaderboard.find_or_create_by(
      name: 'Admin Leaderboard 2',
      competition: euros,
      user: doug
    )
    Membership.find_or_create_by(leaderboard: leaderboard, user: trouni)
    Membership.find_or_create_by(leaderboard: leaderboard, user: james)
    Membership.find_or_create_by(leaderboard: leaderboard, user: renato)
    Membership.find_or_create_by(leaderboard: leaderboard, user: caio)
  end

end

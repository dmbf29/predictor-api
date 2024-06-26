namespace :euros do
  desc "Create the UEFA Euros competition"
  task create: :environment do
    groups = {
      'Group A' => {
        api_id: nil,
        api_code: 'GROUP_A',
        teams: [
          { name: 'Germany', abbrev: 'GER' },
          { name: 'Scotland', abbrev: 'SCO' },
          { name: 'Switzerland', abbrev: 'SUI' },
          { name: 'Hungary', abbrev: 'HUN' }
        ]
      },
      'Group B' => {
        api_id: nil,
        api_code: 'GROUP_B',
        teams: [
          { name: 'Albania', abbrev: 'ALB' },
          { name: 'Italy', abbrev: 'ITA' },
          { name: 'Croatia', abbrev: 'CRO' },
          { name: 'Spain', abbrev: 'ESP' }
        ]
      },
      'Group C' => {
        api_id: nil,
        api_code: 'GROUP_C',
        teams: [
          { name: 'Denmark', abbrev: 'DEN' },
          { name: 'England', abbrev: 'ENG' },
          { name: 'Serbia', abbrev: 'SRB' },
          { name: 'Slovenia', abbrev: 'SVN' }
        ]
      },
      'Group D' => {
        api_id: nil,
        api_code: 'GROUP_D',
        teams: [
          { name: 'France', abbrev: 'FRA' },
          { name: 'Netherlands', abbrev: 'NED' },
          { name: 'Austria', abbrev: 'AUT' },
          { name: 'Poland', abbrev: 'POL' }
        ]
      },
      'Group E' => {
        api_id: nil,
        api_code: 'GROUP_E',
        teams: [
          { name: 'Belgium', abbrev: 'BEL' },
          { name: 'Romania', abbrev: 'ROU' },
          { name: 'Slovakia', abbrev: 'SVK' },
          { name: 'Ukraine', abbrev: 'UKR' }
        ]
      },
      'Group F' => {
        api_id: nil,
        api_code: 'GROUP_F',
        teams: [
          { name: 'Georgia', abbrev: 'GEO' },
          { name: 'Portugal', abbrev: 'POR' },
          { name: 'Czechia', abbrev: 'CZE' },
          { name: 'Turkey', abbrev: 'TUR' }
        ]
      },
    }
    puts 'Creating the Euros...'
    euros = Competition.find_or_create_by!(name: 'Euros 2024', start_date: Date.new(2024, 06, 14), end_date: Date.new(2024, 07, 14), api_id: 2018, api_code: 'EC')
    puts '.. created the Euros'

    puts 'Creating or finding first round...'
    first_round = Round.find_or_create_by!(name: 'Group Stage', number: 1, competition: euros, api_name: 'GROUP_STAGE')
    euros.update!(current_round: first_round)
    Round.find_or_create_by!(name: 'Round of 16', number: 2, competition: euros, api_name: 'LAST_16')
    Round.find_or_create_by!(name: 'Quarter-finals', number: 3, competition: euros, api_name: 'QUARTER_FINALS')
    Round.find_or_create_by!(name: 'Semi-finals', number: 4, competition: euros, api_name: 'SEMI_FINALS')
    # TODO: Doesn't look like the API has the 3rd place playoff
    # Round.find_or_create_by!(name: 'Third Place', number: 5, competition: euros, api_name: '3PPO')
    Round.find_or_create_by!(name: 'Final', number: 6, competition: euros, api_name: 'FINAL')

    puts 'Creating or finding groups...'
    groups.each_key do |group_name|
      puts "...#{group_name}..."
      group = Group.find_or_create_by!(name: group_name, round: first_round, api_id: groups[group_name][:api_id], api_code: groups[group_name][:api_code])
      groups[group_name][:teams].each do |team_hash|
        puts "Name: #{team_hash[:name]}, Abbrev: #{team_hash[:abbrev]}"
        team = Team.find_by(abbrev: team_hash[:abbrev]) || Team.create!(team_hash)
        Affiliation.find_or_create_by!(team: team, group: group)
      end
    end
    # Calling the API to create the matches
    MatchUpdateJob.perform_now(euros.id)

    # TODO: this only works when there are matches so you'll see 1 for now
    puts "...#{euros.rounds.count} Total Round"
    puts "...#{euros.teams.count} Total Teams"
    puts "...#{euros.groups.count} Total Groups"

    doug = User.find_by(email: 'douglasmberkley@gmail.com') || User.create(email: 'douglasmberkley@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
    trouni = User.find_by(email: 'trouni@gmail.com') || User.create(email: 'trouni@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
    james = User.find_by(email: 'devereuxjj@gmail.com') || User.create(email: 'devereuxjj@gmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
    renato = User.find_by(email: 'renatonato_jr@hotmail.com') || User.create(email: 'renatonato_jr@hotmail.com', password: ENV['ADMIN_PASSWORD'], admin: true)
    caio = User.find_by(email: 'caio.santos@msn.com') || User.create(email: 'caio.santos@msn.com', password: ENV['ADMIN_PASSWORD'], admin: true)

    puts 'Creating test leaderboards'
    leaderboard = Leaderboard.find_or_create_by!(
      name: 'Admin Leaderboard 1',
      competition: euros,
      user: trouni
    )
    Membership.find_or_create_by!(leaderboard: leaderboard, user: doug)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: james)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: renato)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: caio)

    leaderboard = Leaderboard.find_or_create_by!(
      name: 'Admin Leaderboard 2',
      competition: euros,
      user: doug
    )
    Membership.find_or_create_by!(leaderboard: leaderboard, user: trouni)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: james)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: renato)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: caio)

    AttachFlagsJob.perform_now(euros.id)
  end

end

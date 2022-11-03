namespace :competition do
  desc "Create World Cup 2022"
  task world_cup: :environment do
    groups = {
      'Group A' => [
        { name: 'Qatar', abbrev: 'QAT' },
        { name: 'Ecuador', abbrev: 'ECU' },
        { name: 'Senegal', abbrev: 'SEN' },
        { name: 'Netherlands', abbrev: 'NED' }
      ],
      'Group B' => [
        { name: 'England', abbrev: 'ENG' },
        { name: 'IR Iran', abbrev: 'IRN' },
        { name: 'USA', abbrev: 'USA' },
        { name: 'Wales', abbrev: 'WAL' }
      ],
      'Group C' => [
        { name: 'Argentina', abbrev: 'ARG' },
        { name: 'Saudi Arabia', abbrev: 'KSA' },
        { name: 'Mexico', abbrev: 'MEX' },
        { name: 'Poland', abbrev: 'POL' }
      ],
      'Group D' => [
        { name: 'France', abbrev: 'FRA' },
        { name: 'Australia', abbrev: 'AUS' },
        { name: 'Denmark', abbrev: 'DEN' },
        { name: 'Tunisia', abbrev: 'TUN' }
      ],
      'Group E' => [
        { name: 'Spain', abbrev: 'ESP' },
        { name: 'Costa Rica', abbrev: 'CRC' },
        { name: 'Germany', abbrev: 'GER' },
        { name: 'Japan', abbrev: 'JPN' }
      ],
      'Group F' => [
        { name: 'Belgium', abbrev: 'BEL' },
        { name: 'Canada', abbrev: 'CAN' },
        { name: 'Morocco', abbrev: 'MAR' },
        { name: 'Croatia', abbrev: 'CRO' }
      ],
      'Group G' => [
        { name: 'Brazil', abbrev: 'BRA' },
        { name: 'Serbia', abbrev: 'SRB' },
        { name: 'Switzerland', abbrev: 'SUI' },
        { name: 'Camerooon', abbrev: 'CMR' }
      ],
      'Group H' => [
        { name: 'Portugal', abbrev: 'POR' },
        { name: 'Ghana', abbrev: 'GHA' },
        { name: 'Uruguay', abbrev: 'URU' },
        { name: 'Korea Republic', abbrev: 'KOR' }
      ]
    }
    puts 'Creating the World Cup...'
    world_cup = Competition.find_or_create_by(name: 'World Cup 2022', start_date: Date.new(2022, 11, 20), end_date: Date.new(2022, 12, 18))
    puts '.. created the World Cup'

    puts 'Creating or finding first round...'
    first_round = Round.find_or_create_by(name: 'Group Stage', number: 1, competition: world_cup, api_name: '3')
    puts "...#{world_cup.rounds.count} Total Rounds"

    puts 'Creating or finding groups...'
    groups.each_key do |group_name|
      puts "...#{group_name}..."
      group = Group.find_or_create_by!(name: group_name, round: first_round)
      groups[group_name].each do |team_hash|
        puts "Name: #{team_hash[:name]}, Abbrev: #{team_hash[:abbrev]}"
        team = Team.find_or_create_by(team_hash)
        Affiliation.find_or_create_by(team: team, group: group)
      end
    end
    puts "...#{world_cup.teams.count} Total Teams"
    puts "...#{world_cup.groups.count} Total Groups"

    doug = User.find_by(email: 'douglasmberkley@gmail.com')
    trouni = User.find_by(email: 'trouni@gmail.com')

    puts 'Creating a test leaderboards'
    leaderboard = Leaderboard.find_or_create_by(
      name: 'Admin Leaderboard',
      competition: world_cup,
      user: trouni
    )
    Membership.find_or_create_by(leaderboard: leaderboard, user: doug)
    leaderboard = Leaderboard.find_or_create_by(
      name: 'Admin Leaderboard',
      competition: world_cup,
      user: doug
    )
    Membership.find_or_create_by(leaderboard: leaderboard, user: trouni)
  end

  desc "Update upcoming fixtures for on-going competitions"
  task update_ongoing_matches: :environment do
    competitions = Competition.on_going
    competitions.each do |competition|
      MatchUpdateFutureJob.perform_later(competition.id)
      MatchUpdateHistoryJob.perform_later(competition.id)
    end
  end

  desc "Update upcoming fixtures for a competition"
  task :update_matches_future, [:competition_id] => :environment do |t, args|
    competition = Competition.find(args[:competition_id])
    MatchUpdateFutureJob.perform_later(competition.id)
  end

  desc "Update upcoming fixtures for a competition"
  task :update_matches_history, [:competition_id] => :environment do |t, args|
    competition = Competition.find(args[:competition_id])
    MatchUpdateHistoryJob.perform_later(competition.id)
  end

  desc "Copy the first competition and start it today"
  task copy: :environment do
    euros = Competition.find_or_create_by!(name: 'Euro 2020')

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
    euros_test = Competition.find_or_create_by!(name: 'Euro Test 2020', start_date: Date.today, end_date: Date.today + 35.days)
    puts '.. created the Euros_test'

    puts 'Creating or finding first round...'
    first_round = Round.find_or_create_by!(name: 'Group Stage', number: 1, competition: euros_test)
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

    euros.matches.each do |match|
      new_match = match.dup
      new_match.group = euros_test.groups.find_by(name: match.group.name)
      new_match.kickoff_time = match.kickoff_time - 9.days
      new_match.team_home_score = nil
      new_match.team_away_score = nil
      new_match.status = "upcoming"
      new_match.save
    end
  end

end

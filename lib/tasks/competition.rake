namespace :competition do
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

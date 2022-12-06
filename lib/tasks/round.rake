namespace :round do
  desc 'Creating the rounds for the Euros'
  task create_all: :environment do
    world_cup = Competition.find_by(name: 'World Cup 2022')

    puts 'Creating or finding first round...'
    # First round was created when the competition was created. Next time, run all together
    # Round.find_or_create_by!(name: 'Group Stage', number: 1, competition: world_cup, api_name: '3')
    Round.find_or_create_by!(name: 'Round of 16', number: 2, competition: world_cup, api_name: 'R16')
    Round.find_or_create_by!(name: 'Quarter-finals', number: 3, competition: world_cup, api_name: 'QF')
    Round.find_or_create_by!(name: 'Semi-finals', number: 4, competition: world_cup, api_name: 'SF')
    Round.find_or_create_by!(name: 'Third Place', number: 5, competition: world_cup, api_name: '3PPO')
    Round.find_or_create_by!(name: 'Final', number: 6, competition: world_cup, api_name: 'F')
    puts "...#{world_cup.rounds.count} Total Rounds"
  end
end

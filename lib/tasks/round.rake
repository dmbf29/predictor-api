namespace :round do
  desc 'Creating the rounds for the Euros'
  task create_all: :environment do
    euros = Competition.find_by(name: 'Euro 2020')

    puts 'Creating or finding first round...'
    # Round.find_or_create_by!(name: 'Group Stage', number: 1, competition: euros, api_name: '3')
    Round.find_or_create_by!(name: 'Round of 16', number: 2, competition: euros, api_name: 'R16')
    Round.find_or_create_by!(name: 'Quarter-finals', number: 3, competition: euros, api_name: 'QF')
    Round.find_or_create_by!(name: 'Semi-finals', number: 4, competition: euros, api_name: 'SF')
    Round.find_or_create_by!(name: 'Final', number: 5, competition: euros, api_name: 'F')
    puts "...#{euros.rounds.count} Total Rounds"
  end
end

namespace :match do
  desc "Randomly assigns results for the first 5 matches"
  task add_fake_results: :environment do
    @competition = Competition.last
    completed_matches = @competition.matches.order(kickoff_time: :asc).first(5)
    completed_matches.each do |match|
      match.finished!
      match.team_home_score = rand(0..3)
      match.team_away_score = rand(0..3)
      match.save
      puts "#{match.team_home.name} vs. #{match.team_away.name}"
      puts "#{match.team_home_score} vs. #{match.team_away_score}"
    end
  end

  desc "Restarts all the matches"
  task restart_all: :environment do
    @competition = Competition.last
    completed_matches = @competition.matches.order(kickoff_time: :asc)
    completed_matches.each do |match|
      match.upcoming!
      match.team_home_score = nil
      match.team_away_score = nil
      match.save
      puts "#{match.team_home.name} vs. #{match.team_away.name} restarted"
    end
  end
end

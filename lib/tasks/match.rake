namespace :match do
  desc "Randomly assigns results for the first 5 matches"
  task add_fake_results: :environment do
    return 'Not allowed in production' if Rails.env.production?

    @competition = Competition.last
    completed_matches = @competition.matches.order(kickoff_time: :asc).first(7)
    completed_matches.each_with_index do |match, index|
      puts "#{match.team_home.name} (H) vs. #{match.team_away.name} (A)"
      User.where(admin: true).each do |user|
        prediction = Prediction.find_or_initialize_by(user: user, match: match)
        prediction.choice = Prediction.choices.keys.sample
        prediction.save
        puts "- #{prediction.user.name} choose #{prediction.choice}"
      end
      if [5, 6].include?(index)
        match.started!
        match.minute = rand(1..90)
      else
        match.finished!
      end
      match.team_home_score = rand(0..3)
      match.team_away_score = rand(0..3)
      match.save
      puts "Result: #{match.team_home_score} vs. #{match.team_away_score}"
      puts
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

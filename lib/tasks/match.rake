namespace :match do
  desc "Checks for matches in the past and randomly assigns a score"
  task add_fake_results: :environment do
    # TODO: Turn off before Friday
    completed_matches = Match.where('kickoff_time < :date', date: DateTime.now)
    completed_matches.each do |match|
      next if match.finished?

      match.finished!
      match.team_home_score = rand(0..3)
      match.team_away_score = rand(0..3)
      match.save
    end
  end
end

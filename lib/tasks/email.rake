namespace :email do
  desc "TODO"
  task match_missing: :environment do
    competition = Competition.find(70)
    match = Match.find(471)

    users_with_predictions = competition.users_predicted
    users_missing_prediction = users_with_predictions
      .with_email_prediction_missing
      .where.not(id: match.predictions.select(:user_id))
    users_missing_prediction.each do |user|
      UserMailer.with(user: user).match_missing.deliver_now
    end
  end

end

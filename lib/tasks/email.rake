namespace :email do
  desc "TODO"
  task match_missing: :environment do
    competition = Competition.find(70)
    match = Match.find(471)

    users_with_predictions = competition.users_predicted
    users_missing_prediction = users_with_predictions
      .with_email_prediction_missing
      .where.not(id: match.predictions.select(:user_id))
    notification_key = "match_missing_match_#{match.id}"
    users_missing_prediction.find_each do |user|
      next if Email.exists?(user: user, topic: nil, notification: notification_key)

      UserMailer.with(user: user, notification: notification_key).match_missing.deliver_later
    end
  end

end

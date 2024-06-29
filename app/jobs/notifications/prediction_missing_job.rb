class Notifications::PredictionMissingJob < ApplicationJob
  queue_as :default

  def perform(match_ids)
    matches = Match.where(id: match_ids)
    matches.each do |match|
      # loads all users in this competition that have emailing turned on
      users_to_email = User.need_prediction_notifications(match)
      users_to_email.each do |user|
        # Checks to see if an email has already been sent
        email = Email.find_by(user: user, topic: match, notification: 'prediction_missing')
        UserMailer.with(user: user, match: match, notification: 'prediction_missing').prediction_missing.deliver_later unless email
      end
    end
  end
end

class Notifications::PredictionMissingJob < ApplicationJob
  queue_as :default

  def perform(match_ids)
    # email
    users_to_email = User.where("notifications->'email'->>'prediction_missing' = ?", 'true')
    users_to_email.each do |user|
      Email::PredictionMissingJob.perform_later(user.id, match_ids)
    end
  end
end

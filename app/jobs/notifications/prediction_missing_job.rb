class Notifications::PredictionMissingJob < ApplicationJob
  queue_as :default

  def perform(round_ids)
    rounds = Round.where(id: round_ids)
    rounds.each do |round|
      match_ids = round.matches.pluck(:id)
      users_to_email = User.need_prediction_notifications(round)
      users_to_email.each do |user|
        next if Email.exists?(user: user, topic: round, notification: 'prediction_missing')

        missing_count = match_ids.count - user.predictions.where(match_id: match_ids).count
        UserMailer.with(user: user, round: round, missing_count: missing_count, notification: 'prediction_missing').prediction_missing.deliver_later
      end
    end
  end
end

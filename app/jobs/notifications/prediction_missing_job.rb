class Notifications::PredictionMissingJob < ApplicationJob
  queue_as :default

  def perform(round_id, matchday = nil)
    round = Round.find(round_id)
    matches = matchday ? round.matches.where(matchday: matchday) : round.matches
    match_ids = matches.pluck(:id)
    notification_key = matchday ? "prediction_missing_matchday_#{matchday}" : 'prediction_missing'

    users_to_email = User.need_prediction_notifications(round, match_ids: match_ids)
    users_to_email.each do |user|
      next if Email.exists?(user: user, topic: round, notification: notification_key)

      missing_count = match_ids.count - user.predictions.where(match_id: match_ids).count

      UserMailer.with(
        user: user,
        round: round,
        matchday: matchday,
        missing_count: missing_count,
        notification: notification_key
      ).prediction_missing.deliver_later
    end
  end
end

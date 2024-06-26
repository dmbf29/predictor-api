class Email::PredictionMissingJob < ApplicationJob
  queue_as :default

  def perform(user_id, match_ids)
    user = User.find(user_id)
  end
end

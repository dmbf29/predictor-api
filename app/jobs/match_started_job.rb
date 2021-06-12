class MatchStartedJob < ApplicationJob
  queue_as :default

  def perform(kickoff_time)
    matches = Match.where(kickoff_time: kickoff_time)
    matches.map(&:started!)
  end
end

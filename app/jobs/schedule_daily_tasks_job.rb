class ScheduleDailyTasksJob < ApplicationJob
  queue_as :default

  def perform
    competitions = Competition.on_going
    competitions.each do |competition|
      # Schedules the matches as "started" based on their kickoff_time
      matches = competition.matches.where(kickoff_time: Date.today.all_day)
      matches.pluck(:kickoff_time).uniq.each do |kickoff_time|
        MatchStartedJob.set(wait_until: kickoff_time).perform_later(kickoff_time)
      end
      # Schedules notifications for missing predicitions
      matches_tomorrow = competition.matches.where(kickoff_time: Date.tomorrow.all_day)
      Notifications::PredictionMissingJob.perform_later(matches_tomorrow.pluck(:id))
    end
  end
end

class ScheduleDailyTasksJob < ApplicationJob
  queue_as :default

  def perform
    competitions = Competition.on_going
    competitions.each do |competition|
      matches = competition.matches.where(kickoff_time: Date.today.all_day)
      matches.pluck(:kickoff_time).uniq.each do |kickoff_time|

      # Update right after kickoff and after the game
      MatchStartedJob.set(wait_until: kickoff_time).perform_later(kickoff_time)
      MatchUpdateHistoryJob.set(wait_until: kickoff_time + 100.minutes).perform_later(competition.id)
    end
  end
end

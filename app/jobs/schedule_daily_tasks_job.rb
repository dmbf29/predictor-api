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
      # Schedules notifications for rounds starting tomorrow
      rounds_starting_tomorrow = Round.joins(:matches)
        .where(competition: competition)
        .group('rounds.id')
        .having('MIN(matches.kickoff_time) BETWEEN ? AND ?', Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day)
      Notifications::PredictionMissingJob.perform_later(rounds_starting_tomorrow.pluck(:id))
    end
  end
end

class ScheduleDailyTasksJob < ApplicationJob
  queue_as :default

  def perform
    competitions = Competition.on_going
    competitions.each do |competition|
      # Schedules the matches as "started" based on their kickoff_time
      matches = competition.matches.where(kickoff_time: Date.today.all_day)
      matches.pluck(:kickoff_time).uniq.each do |kickoff_time|
        MatchStartedJob.set(wait_until: kickoff_time).perform_later(kickoff_time)
        # Calls the API during the matches to get the current time
        150.times do |i|
          MatchUpdateJob.set(wait_until: kickoff_time + i.minutes).perform_later(competition.id)
        end
      end
      tomorrow_matches = competition.matches.where(kickoff_time: Date.tomorrow.all_day)

      # Group stage: notify only when the first kickoff of the matchday is tomorrow
      competition.matches.where.not(matchday: nil)
        .group(:round_id, :matchday)
        .having('MIN(kickoff_time) BETWEEN ? AND ?', Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day)
        .pluck(:round_id, :matchday)
        .each do |(round_id, matchday)|
          Notifications::PredictionMissingJob.perform_later(round_id, matchday)
        end

      # Knockout rounds: notify only on the first day of the round
      knockout_round_ids = tomorrow_matches.where(matchday: nil).select(:round_id)
      Round.joins(:matches)
        .where(competition: competition, id: knockout_round_ids)
        .group('rounds.id')
        .having('MIN(matches.kickoff_time) BETWEEN ? AND ?', Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day)
        .pluck(:id)
        .each { |round_id| Notifications::PredictionMissingJob.perform_later(round_id) }
    end
  end
end

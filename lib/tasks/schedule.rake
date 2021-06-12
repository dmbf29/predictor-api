namespace :schedule do
  desc "Runs at midnight(~) to schedule daily background jobs"
  task daily: :environment do
    ScheduleDailyTasksJob.perform_later
  end

end

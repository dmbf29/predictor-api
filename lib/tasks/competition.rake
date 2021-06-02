namespace :competition do
  desc "Copy the first competition and start it today"
  task copy: :environment do
    euros = Competition.first
    competition = euros.dup
    competition.save

  end

end

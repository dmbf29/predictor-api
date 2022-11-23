namespace :user do
  desc "Scrapes a photo from worlcup.com and attaches to users who don't have an image"
  task :attach_photos, [:competition_id] => :environment do |t, args|
    competition = Competition.find(args[:competition_id])
    competition.users.uniq.each do |user|
      next if user.photo_key

      ScrapePhotoService.new(user: user, competition: competition).call
    end
  end
end

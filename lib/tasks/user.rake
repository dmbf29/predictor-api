namespace :user do
  desc "Takes uploads from Cloudinary and attaches to users who don't have an image"
  task :attach_photos, [:competition_id] => :environment do |t, args|
    competition = Competition.find(args[:competition_id])
    competition.users.uniq.each do |user|
      next if user.photo_key

      user.update(photo_key: User::DEFAULT_AVATARS.sample)
      # Old Scraping method
      # ScrapePhotoService.new(user: user, competition: competition).call
    end
  end

  desc "Uploads all photos in the folder to Cloudinary"
  task upload_photos: :environment do
    # script/upload_thumbs.rb

  require "cloudinary"

  thumbs_dir = Rails.root.join("db", "thumbs")

  files = Dir.glob(thumbs_dir.join("*.{avif,jpg,jpeg,png,webp,JPG,JPEG,PNG,WEBP}"))

  puts "Found #{files.count} image(s)."

  public_ids = []

  files.each do |file_path|
    filename = File.basename(file_path, ".*")

    result = Cloudinary::Uploader.upload(
      file_path,
      public_id: filename.downcase,
      overwrite: true,
      transformation: [
        {
          width: 200,
          height: 200,
          crop: "thumb",
          gravity: "face",
          zoom: 0.75
        }
      ]
    )

    public_ids << result["public_id"]

    puts "✓ Uploaded #{filename}"
    puts "  Public ID: #{result["public_id"]}"
    puts
  end

  puts
  puts "=== PUBLIC IDS ==="
  puts
  puts "DEFAULT_AVATARS = %w["
  public_ids.each do |id|
    puts "  #{id}"
  end
  puts "]"

  end
end

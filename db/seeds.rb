Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |filename|
  puts "------> Seeding #{filename}..."
  load(filename)
end

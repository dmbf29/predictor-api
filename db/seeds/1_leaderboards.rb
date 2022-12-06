LEADERBOARDS = [
  {
    name: 'Global Top 10',
    description: 'The Top 10 players on Octacle',
    rankings_top_n: 10,
    leave_disabled: true,
    auto_join: true,
  }
]

admin = User.find_by(email: 'trouni@gmail.com')

puts '-----> Seeding auto-join leaderboards...'
LEADERBOARDS.each do |leaderboard_hash|
  Competition.find_each do |competition|
    leaderboard = competition.leaderboards.find_or_initialize_by(leaderboard_hash.slice(:name))
    leaderboard.assign_attributes(leaderboard_hash)
    leaderboard.user ||= admin
    leaderboard.save!

    puts "-----> Creating memberships for #{leaderboard.name} (#{leaderboard.competition.name})"
    bar = ProgressBar.new(User.count)
    User.find_each do |user|
      leaderboard.memberships.find_or_create_by!(user: user)
      bar.increment!
    end
  end
end

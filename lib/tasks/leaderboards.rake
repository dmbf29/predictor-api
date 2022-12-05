namespace :leaderboards do
  desc 'Seed auto-join leaderboards'
  task seed: :environment do
    puts '-----> Seeding auto-join leaderboards...'
    trouni = User.find_by(email: 'trouni@gmail.com')
    global = Leaderboard.find_or_create_by(
      name: 'Global Ranking',
      auto_join: true,
      user: trouni,
      competition: Competition.find_by(name: 'World Cup 2022')
    )
    puts '-----> Create memberships...'
    User.where.not(id: global.users.pluck(:id)).find_each do |user|
      global.users << user
      print '.'
    end
  end
end

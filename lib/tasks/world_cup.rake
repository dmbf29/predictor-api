require 'open-uri'

namespace :world_cup do
  desc "Create the FIFA World Cup 2026 competition"
  task create: :environment do

    # So apparently there is a job to create a competition... but it doesn't work and this one does ATM.
    groups = {
      'Group A' => {
        api_id: nil,
        api_code: 'GROUP_A',
        teams: [
          { name: 'Mexico', abbrev: 'MEX', ranking: 15, api_id: 769 },
          { name: 'South Africa', abbrev: 'RSA', ranking: 60, api_id: 774 },
          { name: 'South Korea', abbrev: 'KOR', ranking: 25, api_id: 772 },
          { name: 'Czechia', abbrev: 'CZE', ranking: 41, api_id: 798 }
        ]
      },
      'Group B' => {
        api_id: nil,
        api_code: 'GROUP_B',
        teams: [
          { name: 'Canada', abbrev: 'CAN', ranking: 30, api_id: 828 },
          { name: 'Bosnia-Herzegovina', abbrev: 'BIH', ranking: 60, api_id: 1060 },
          { name: 'Qatar', abbrev: 'QAT', ranking: 55, api_id: 8030 },
          { name: 'Switzerland', abbrev: 'SUI', ranking: 19, api_id: 788 }
        ]
      },
      'Group C' => {
        api_id: nil,
        api_code: 'GROUP_C',
        teams: [
          { name: 'Brazil', abbrev: 'BRA', ranking: 6, api_id: 764 },
          { name: 'Morocco', abbrev: 'MAR', ranking: 7, api_id: 815 },
          { name: 'Haiti', abbrev: 'HAI', ranking: 82, api_id: 836 },
          { name: 'Scotland', abbrev: 'SCO', ranking: 43, api_id: 8873 }
        ]
      },
      'Group D' => {
        api_id: nil,
        api_code: 'GROUP_D',
        teams: [
          { name: 'United States', abbrev: 'USA', ranking: 16, api_id: 771 },
          { name: 'Paraguay', abbrev: 'PAR', ranking: 40, api_id: 761 },
          { name: 'Australia', abbrev: 'AUS', ranking: 27, api_id: 779 },
          { name: 'Turkey', abbrev: 'TUR', ranking: 22, api_id: 803 }
        ]
      },
      'Group E' => {
        api_id: nil,
        api_code: 'GROUP_E',
        teams: [
          { name: 'Germany', abbrev: 'GER', ranking: 10, api_id: 759 },
          { name: 'Curaçao', abbrev: 'CUW', ranking: 83, api_id: 9460 },
          { name: 'Ivory Coast', abbrev: 'CIV', ranking: 34, api_id: 1935 },
          { name: 'Ecuador', abbrev: 'ECU', ranking: 24, api_id: 791 }
        ]
      },
      'Group F' => {
        api_id: nil,
        api_code: 'GROUP_F',
        teams: [
          { name: 'Netherlands', abbrev: 'NED', ranking: 8, api_id: 8601 },
          { name: 'Japan', abbrev: 'JPN', ranking: 18, api_id: 766 },
          { name: 'Sweden', abbrev: 'SWE', ranking: 38, api_id: 792 },
          { name: 'Tunisia', abbrev: 'TUN', ranking: 46, api_id: 802 }
        ]
      },
      'Group G' => {
        api_id: nil,
        api_code: 'GROUP_G',
        teams: [
          { name: 'Belgium', abbrev: 'BEL', ranking: 9, api_id: 805 },
          { name: 'Egypt', abbrev: 'EGY', ranking: 29, api_id: 825 },
          { name: 'Iran', abbrev: 'IRN', ranking: 21, api_id: 840 },
          { name: 'New Zealand', abbrev: 'NZL', ranking: 85, api_id: 783 }
        ]
      },
      'Group H' => {
        api_id: nil,
        api_code: 'GROUP_H',
        teams: [
          { name: 'Spain', abbrev: 'ESP', ranking: 2, api_id: 760 },
          { name: 'Cape Verde Islands', abbrev: 'CPV', ranking: 68, api_id: 1930 },
          { name: 'Saudi Arabia', abbrev: 'KSA', ranking: 61, api_id: 801 },
          { name: 'Uruguay', abbrev: 'URY', ranking: 17, api_id: 758 }
        ]
      },
      'Group I' => {
        api_id: nil,
        api_code: 'GROUP_I',
        teams: [
          { name: 'Iraq', abbrev: 'IRQ', ranking: 57, api_id: 8062 },
          { name: 'France', abbrev: 'FRA', ranking: 1, api_id: 773 },
          { name: 'Senegal', abbrev: 'SEN', ranking: 14, api_id: 804 },
          { name: 'Norway', abbrev: 'NOR', ranking: 31, api_id: 8872 }
        ]
      },
      'Group J' => {
        api_id: nil,
        api_code: 'GROUP_J',
        teams: [
          { name: 'Argentina', abbrev: 'ARG', ranking: 3, api_id: 762 },
          { name: 'Algeria', abbrev: 'ALG', ranking: 28, api_id: 778 },
          { name: 'Austria', abbrev: 'AUT', ranking: 23, api_id: 816 },
          { name: 'Jordan', abbrev: 'JOR', ranking: 63, api_id: 8049 }
        ]
      },
      'Group K' => {
        api_id: nil,
        api_code: 'GROUP_K',
        teams: [
          { name: 'Congo DR', abbrev: 'COD', ranking: 45, api_id: 1934 },
          { name: 'Portugal', abbrev: 'POR', ranking: 5, api_id: 765 },
          { name: 'Uzbekistan', abbrev: 'UZB', ranking: 50, api_id: 8070 },
          { name: 'Colombia', abbrev: 'COL', ranking: 13, api_id: 818 }
        ]
      },
      'Group L' => {
        api_id: nil,
        api_code: 'GROUP_L',
        teams: [
          { name: 'England', abbrev: 'ENG', ranking: 4, api_id: 770 },
          { name: 'Croatia', abbrev: 'CRO', ranking: 11, api_id: 799 },
          { name: 'Ghana', abbrev: 'GHA', ranking: 73, api_id: 763 },
          { name: 'Panama', abbrev: 'PAN', ranking: 33, api_id: 1836 }
        ]
      }
    }

    puts 'Creating the World Cup...'
    world_cup = Competition.find_or_create_by!(
      name: 'FIFA World Cup 2026',
      start_date: Date.new(2026, 6, 11),
      end_date: Date.new(2026, 7, 19)
    )
    world_cup.update!(
      api_id: 2000,
      api_code: 'WC'
    )
    unless world_cup.photo.attached?
      file = URI.parse("https://crests.football-data.org/wm26.png").open
      world_cup.photo.attach(io: file, filename: 'logo.png', content_type: 'image/png')
    end
    puts '.. created the World Cup'

    puts 'Creating or finding rounds...'
    rounds = [
      { name: 'Group Stage', number: 1, api_name: 'GROUP_STAGE' },
      { name: 'Round of 32', number: 2, api_name: 'LAST_32' },
      { name: 'Round of 16', number: 3, api_name: 'LAST_16' },
      { name: 'Quarter-finals', number: 4, api_name: 'QUARTER_FINALS' },
      { name: 'Semi-finals', number: 5, api_name: 'SEMI_FINALS' },
      { name: 'Third Place', number: 6, api_name: 'THIRD_PLACE' },
      { name: 'Final', number: 7, api_name: 'FINAL' }
    ]

    first_round = nil
    rounds.each do |round_attrs|
      round = Round.find_or_create_by!(
        competition: world_cup,
        name: round_attrs[:name],
        number: round_attrs[:number]
      )
      round.update!(
        api_name: round_attrs[:api_name]
      )
      first_round ||= round if round_attrs[:name] == 'Group Stage'
    end
    world_cup.update!(current_round: first_round)

    puts 'Creating or finding groups...'
    groups.each_key do |group_name|
      puts "...#{group_name}..."
      group = Group.find_or_create_by!(name: group_name, round: first_round, api_id: groups[group_name][:api_id], api_code: groups[group_name][:api_code])
      groups[group_name][:teams].each do |team_hash|
        puts "Name: #{team_hash[:name]}, Abbrev: #{team_hash[:abbrev]}"
        team = Team.find_by(abbrev: team_hash[:abbrev]) || Team.find_or_create_by!(abbrev: team_hash[:abbrev], name: team_hash[:name])
        team.update!(api_id: team_hash[:api_id], name: team_hash[:name], ranking: team_hash[:ranking])
        Affiliation.find_or_create_by!(team: team, group: group)
      end
    end

    puts "...#{Round.where(competition: world_cup).count} Total Rounds"
    puts "...#{Team.joins(affiliations: { group: :round }).where(rounds: { competition_id: world_cup.id }).distinct.count} Total Teams"
    puts "...#{Group.joins(:round).where(rounds: { competition_id: world_cup.id }).count} Total Groups"

    puts 'Getting Admin users...'
    admin_emails = [
      'douglasmberkley@gmail.com',
      'trouni@gmail.com',
      'devereuxjj@gmail.com',
      'renatonato_jr@hotmail.com',
      'caio.santos@msn.com'
    ]
    admin_password = ENV['ADMIN_PASSWORD']

    if admin_password.blank? && admin_emails.any? { |email| User.find_by(email: email).nil? }
      raise 'ADMIN_PASSWORD must be set to create missing admin users.'
    end

    doug = User.find_or_create_by!(email: 'douglasmberkley@gmail.com') do |user|
      user.password = admin_password
      user.admin = true
    end
    trouni = User.find_or_create_by!(email: 'trouni@gmail.com') do |user|
      user.password = admin_password
      user.admin = true
    end
    james = User.find_or_create_by!(email: 'devereuxjj@gmail.com') do |user|
      user.password = admin_password
      user.admin = true
    end
    renato = User.find_or_create_by!(email: 'renatonato_jr@hotmail.com') do |user|
      user.password = admin_password
      user.admin = true
    end
    caio = User.find_or_create_by!(email: 'caio.santos@msn.com') do |user|
      user.password = admin_password
      user.admin = true
    end
    if Rails.env.development? || ENV['ALLOW_TEST_USER_SEED'] == 'true'
      puts 'Creating test users...'
      20.times do
        email = loop do
          candidate = Faker::Internet.unique.safe_email
          break candidate unless User.exists?(email: candidate)
        end

        User.create!(
          email: email,
          password: '123123'
        )
      end
    else
      puts 'Skipping test users outside development. Set ALLOW_TEST_USER_SEED=true to enable.'
    end
    puts "... #{User.count} Total Users"

    puts 'Creating test leaderboards'
    leaderboard_hash = {
      name: 'Global Top Players',
      description: 'The top players on Octacle',
      rankings_top_n: 10,
      leave_disabled: true,
      auto_join: true,
    }
    leaderboard = world_cup.leaderboards.find_or_initialize_by(leaderboard_hash.slice(:name))
    leaderboard.assign_attributes(leaderboard_hash)
    leaderboard.user ||= doug
    leaderboard.save!



    leaderboard = Leaderboard.find_or_create_by!(
      name: 'Admin Leaderboard 1',
      competition: world_cup,
      user: trouni
    )
    Membership.find_or_create_by!(leaderboard: leaderboard, user: doug)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: james)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: renato)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: caio)

    leaderboard = Leaderboard.find_or_create_by!(
      name: 'Admin Leaderboard 2',
      competition: world_cup,
      user: doug
    )
    Membership.find_or_create_by!(leaderboard: leaderboard, user: trouni)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: james)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: renato)
    Membership.find_or_create_by!(leaderboard: leaderboard, user: caio)

    if ENV['FOOTBALL_DATA_TOKEN'].blank?
      raise 'FOOTBALL_DATA_TOKEN must be set. MatchUpdateJob runs synchronously during setup.'
    end
    MatchUpdateJob.perform_now(world_cup.id)

    AttachFlagsJob.perform_now(world_cup.id)
  end

end

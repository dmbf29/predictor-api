namespace :world_cup do
  desc "Create the FIFA World Cup 2026 competition"
  task create: :environment do
    groups = {
      'Group A' => {
        api_id: nil,
        api_code: 'GROUP_A',
        teams: [
          { name: 'Mexico', abbrev: 'MEX', api_id: 769 },
          { name: 'South Africa', abbrev: 'RSA', api_id: 774 },
          { name: 'South Korea', abbrev: 'KOR', api_id: 772 },
          { name: 'Czechia', abbrev: 'CZE', api_id: 798 }
        ]
      },
      'Group B' => {
        api_id: nil,
        api_code: 'GROUP_B',
        teams: [
          { name: 'Canada', abbrev: 'CAN', api_id: 828 },
          { name: 'Bosnia-Herzegovina', abbrev: 'BIH', api_id: 1060 },
          { name: 'Qatar', abbrev: 'QAT', api_id: 8030 },
          { name: 'Switzerland', abbrev: 'SUI', api_id: 788 }
        ]
      },
      'Group C' => {
        api_id: nil,
        api_code: 'GROUP_C',
        teams: [
          { name: 'Brazil', abbrev: 'BRA', api_id: 764 },
          { name: 'Morocco', abbrev: 'MAR', api_id: 815 },
          { name: 'Haiti', abbrev: 'HAI', api_id: 836 },
          { name: 'Scotland', abbrev: 'SCO', api_id: 8873 }
        ]
      },
      'Group D' => {
        api_id: nil,
        api_code: 'GROUP_D',
        teams: [
          { name: 'United States', abbrev: 'USA', api_id: 771 },
          { name: 'Paraguay', abbrev: 'PAR', api_id: 761 },
          { name: 'Australia', abbrev: 'AUS', api_id: 779 },
          { name: 'Turkey', abbrev: 'TUR', api_id: 803 }
        ]
      },
      'Group E' => {
        api_id: nil,
        api_code: 'GROUP_E',
        teams: [
          { name: 'Germany', abbrev: 'GER', api_id: 759 },
          { name: 'Curaçao', abbrev: 'CUR', api_id: 9460 },
          { name: 'Ivory Coast', abbrev: 'CIV', api_id: 1935 },
          { name: 'Ecuador', abbrev: 'ECU', api_id: 791 }
        ]
      },
      'Group F' => {
        api_id: nil,
        api_code: 'GROUP_F',
        teams: [
          { name: 'Netherlands', abbrev: 'NED', api_id: 8601 },
          { name: 'Japan', abbrev: 'JPN', api_id: 766 },
          { name: 'Sweden', abbrev: 'SWE', api_id: 792 },
          { name: 'Tunisia', abbrev: 'TUN', api_id: 802 }
        ]
      },
      'Group G' => {
        api_id: nil,
        api_code: 'GROUP_G',
        teams: [
          { name: 'Belgium', abbrev: 'BEL', api_id: 805 },
          { name: 'Egypt', abbrev: 'EGY', api_id: 825 },
          { name: 'Iran', abbrev: 'IRN', api_id: 840 },
          { name: 'New Zealand', abbrev: 'NZL', api_id: 783 }
        ]
      },
      'Group H' => {
        api_id: nil,
        api_code: 'GROUP_H',
        teams: [
          { name: 'Spain', abbrev: 'ESP', api_id: 760 },
          { name: 'Cape Verde Islands', abbrev: 'CPV', api_id: 1930 },
          { name: 'Saudi Arabia', abbrev: 'KSA', api_id: 801 },
          { name: 'Uruguay', abbrev: 'URU', api_id: 758 }
        ]
      },
      'Group I' => {
        api_id: nil,
        api_code: 'GROUP_I',
        teams: [
          { name: 'Iraq', abbrev: 'IRQ', api_id: 8062 },
          { name: 'France', abbrev: 'FRA', api_id: 773 },
          { name: 'Senegal', abbrev: 'SEN', api_id: 804 },
          { name: 'Norway', abbrev: 'NOR', api_id: 8872 }
        ]
      },
      'Group J' => {
        api_id: nil,
        api_code: 'GROUP_J',
        teams: [
          { name: 'Argentina', abbrev: 'ARG', api_id: 762 },
          { name: 'Algeria', abbrev: 'ALG', api_id: 778 },
          { name: 'Austria', abbrev: 'AUT', api_id: 816 },
          { name: 'Jordan', abbrev: 'JOR', api_id: 8049 }
        ]
      },
      'Group K' => {
        api_id: nil,
        api_code: 'GROUP_K',
        teams: [
          { name: 'Congo DR', abbrev: 'COD', api_id: 1934 },
          { name: 'Portugal', abbrev: 'POR', api_id: 765 },
          { name: 'Uzbekistan', abbrev: 'UZB', api_id: 8070 },
          { name: 'Colombia', abbrev: 'COL', api_id: 818 }
        ]
      },
      'Group L' => {
        api_id: nil,
        api_code: 'GROUP_L',
        teams: [
          { name: 'England', abbrev: 'ENG', api_id: 770 },
          { name: 'Croatia', abbrev: 'CRO', api_id: 799 },
          { name: 'Ghana', abbrev: 'GHA', api_id: 763 },
          { name: 'Panama', abbrev: 'PAN', api_id: 1836 }
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
        name: round_attrs[:name]
      )
      round.update!(
        number: round_attrs[:number],
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
        team.update!(api_id: team_hash[:api_id], name: team_hash[:name])
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

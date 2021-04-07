# TODO: We'll need to install the drivers to work on Heroku
require 'nokogiri'

class ScrapeMatchesService
  attr_reader :urls, :browser

  def initialize
    # ids pulled from the UEFA website to scrape matches
    @urls = []
    group_stages_ids = [33673, 33674, 33675]
    group_stage_url = 'https://www.uefa.com/uefaeuro-2020/fixtures-results/#/md/'
    group_stages_ids.each { |id| @urls << "#{group_stage_url}#{id}" }

    # TODO: Knockout stages have placeholders for winners of groups, not team names.
    # knockout_ids = [2001025, 2001026, 2001027, 2001028]
    # knockout_url = 'https://www.uefa.com/uefaeuro-2020/fixtures-results/#/rd/'
    # knockout_ids.each { |id| @urls << "#{knockout_url}#{id}" }
  end

  def call
    @browser = Watir::Browser.new :chrome, args: %w[--headless --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugging-port=9222]
    urls.each do |url|
      scrape(url)
    end
  end

  def scrape(url)
    browser.goto url
    sleep(10)
    html_doc = Nokogiri::HTML.parse(browser.html)

    # The HTML is so crazily organized
    # for each match row, there is an h3 with the date (some are hidden) / groups
    dates = html_doc.search('.matches-match_date')
    puts "Found #{dates.count} dates (should be 12)"
    groups = html_doc.search('.match-row_group .match-group')
    puts "Found #{groups.count} groups (should be 12)"

    html_doc.search('.match-row_link').each_with_index do |match_row, index|
      # Tried about 100 ways before I got to this. Others weren't loading in time(?)
      epoch = JSON.parse(match_row.search('.match-row_match').first.attributes["data-options"].value)['match']["MatchDateTime"].delete('/Date()/')
      puts 'Epoch:'
      p epoch

      kickoff_time = DateTime.strptime(epoch, '%Q')
      puts 'Kickoff time:'
      p kickoff_time

      home_name = match_row.search('.team-home .team-name').text.strip
      team_home = Team.find_by(name: home_name)
      puts 'Home team:'
      p team_home

      away_name = match_row.search('.team-away .team-name').text.strip
      team_away = Team.find_by(name: away_name)
      puts 'Away team:'
      p team_away

      group_name = groups[index].attributes['title'].value
      group = Group.find_by(name: group_name)
      puts 'Group:'
      p group

      p Match.find_or_create_by(
        kickoff_time: kickoff_time,
        team_home: team_home,
        team_away: team_away,
        group: group
      )
    end
  end
end

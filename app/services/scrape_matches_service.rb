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
    DatabaseViews.run_without_callback(then_refresh: true) do
      @browser = Watir::Browser.new :chrome, args: %w[--headless --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugging-port=9222]
      urls.each do |url|
        scrape(url)
      end
    end
  end

  def scrape(url)
    browser.goto url
    sleep(10)
    html_doc = Nokogiri::HTML.parse(browser.html)

    # The HTML is crazily organized
    groups = html_doc.search('.match-row_group .match-group')
    puts "Found #{groups.count} groups (should be 12)"

    html_doc.search('.match-row_link').each_with_index do |match_row, index|
      p Match.find_or_create_by(
        kickoff_time: get_kickoff_time(match_row),
        team_home: get_team_home(match_row),
        team_away: get_team_away(match_row),
        group: get_group(groups[index])
      )
    end
  end

  def get_team_home(match_row)
    home_name = match_row.search('.team-home .team-name').text.strip
    puts "Home team: #{home_name}"
    Team.find_by(name: home_name)
  end

  def get_team_away(match_row)
    away_name = match_row.search('.team-away .team-name').text.strip
    puts "Away team: #{away_name}"
    Team.find_by(name: away_name)
  end

  def get_kickoff_time(match_row)
    # Tried about 100 ways before I got to this. Others weren't loading in time(?)
    epoch = JSON.parse(match_row.search('.match-row_match').first.attributes["data-options"].value)['match']["MatchDateTime"].delete('/Date()/')
    puts "Epoch: #{epoch}"
    DateTime.strptime(epoch, '%Q')
  end

  def get_group(group_element)
    group_name = group_element.attributes['title'].value
    puts "Group: #{group_name}"
    Group.find_by(name: group_name)
  end
end

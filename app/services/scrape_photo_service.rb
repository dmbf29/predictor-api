require 'watir'

class ScrapePhotoService
  attr_reader :user, :competition

  def initialize(attrs = {})
    @user = attrs[:user]
    @competition = attrs[:competition]
  end

  def call
    url = "https://www.fifa.com/fifaplus/en/tournaments/mens/worldcup/qatar2022/teams/#{competition.teams.sample.name.split.join('-').downcase}/squad"
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto url
    sleep(15)
    html_doc = Nokogiri::HTML.parse(browser.html)
    main_div = html_doc.search('main section')[2]
    return unless main_div

    forwards = main_div.search('.entire-squad_container__3W4Hl')[3]
    images = forwards.search('.player-badge-card_playerImage__301X0')
    image_url = images[rand(0...images.length)].attribute("style").value.gsub('background-image: url(', '').delete('\"());')
    file = URI.open(image_url)
    puts "#{user.display_name}: \nUploading #{image_url} ..."
    cl_response = Cloudinary::Uploader.upload(file)
    user.photo_key = cl_response['public_id']
    user.save
    # TODO: Most likely the ending numbers and names might change...
    # document.querySelectorAll('main section')[2].querySelectorAll('.entire-squad_container__3W4Hl')[3].querySelectorAll('.player-badge-card_playerImage__301X0')[0].style.backgroundImage
  end
end

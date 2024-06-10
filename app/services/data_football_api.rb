class DataFootballApi
  def self.matches_url(competition_api_code)
    "https://api.football-data.org/v4/competitions/#{competition_api_code}/matches"
  end

  def self.teams_url(competition_api_code)
    "https://api.football-data.org/v4/competitions/#{competition_api_code}/teams"
  end
end

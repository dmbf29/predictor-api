json.array! @matches do |match|
  json.extract! match, :id, :kickoff_time, :team_home_score, :team_away_score, :status, :group_id, :next_match_id, :round_id, :team_away, :team_home
  json.prediction match.predictions.first if match.predictions.any?
end

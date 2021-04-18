json.array! @matches do |match|
  json.extract! match, :id, :kickoff_time, :team_home_score, :team_away_score, :status, :group_id, :team_away_id, :team_home_id, :next_match_id, :round_id
end

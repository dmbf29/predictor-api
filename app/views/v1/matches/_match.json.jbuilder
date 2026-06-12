json.extract! match, :id, :kickoff_time, :status, :group_id, :next_match_id, :round_id, :location, :minute
json.group_name match.group&.name
json.round_number match.round.number
if match.team_home
  json.team_home do
    json.partial! match.team_home
    if %w[finished started].include?(match[:status])
      json.score match.team_home_score
      json.et_score match.team_home_et_score
      json.ps_score match.team_home_ps_score
    end
  end
else
  json.team_home nil
end
if match.team_away
  json.team_away do
    json.partial! match.team_away
    if %w[finished started].include?(match[:status])
      json.score match.team_away_score
      json.et_score match.team_away_et_score
      json.ps_score match.team_away_ps_score
    end
  end
else
  json.team_away nil
end

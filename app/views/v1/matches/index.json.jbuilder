json.array! @matches do |match|
  match.symbolize_keys!
  json.merge! match.slice(:id, :kickoff_time, :status, :group_id, :next_match_id, :round_id)
  json.team_home do
    json.id match[:team_home_id]
    json.name match[:team_home_name]
    json.abbrev match[:team_home_abbrev]
    json.badge_url cl_image_path(match[:team_home_badge_key])
    json.flag_url cl_image_path(match[:team_home_flag_key])
    json.score match[:team_home_score] if match[:status] == 'finished'
  end
  json.team_away do
    json.id match[:team_away_id]
    json.name match[:team_away_name]
    json.abbrev match[:team_away_abbrev]
    json.badge_url cl_image_path(match[:team_away_badge_key])
    json.flag_url cl_image_path(match[:team_away_flag_key])
    json.score match[:team_away_score] if match[:status] == 'finished'
  end
  if match[:prediction_choice]
    json.prediction do
      json.id match[:prediction_id]
      json.choice match[:prediction_choice]
      json.user_id match[:prediction_user_id]
      json.match_id match[:prediction_match_id]
    end
  end
end

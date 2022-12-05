json.array! @matches do |match|
  json.extract! match, :id, :kickoff_time, :status, :group_id, :next_match_id, :round_id, :location
  json.round_number match.round.number
  json.team_home do
    json.id match.team_home.id
    json.name match.team_home.name
    json.abbrev match.team_home.abbrev
    json.badge_url cl_image_path(match.team_home.badge.key)
    json.flag_url cl_image_path(match.team_home.flag.key)
    if match.status == 'finished'
      json.score match.team_home_score
      json.et_score match.team_home_et_score
      json.ps_score match.team_home_ps_score
    end
  end
  json.team_away do
    json.id match.team_away.id
    json.name match.team_away.name
    json.abbrev match.team_away.abbrev
    json.badge_url cl_image_path(match.team_away.badge.key)
    json.flag_url cl_image_path(match.team_away.flag.key)
    if match.status == 'finished'
      json.score match.team_away_score 
      json.et_score match.team_away_et_score
      json.ps_score match.team_away_ps_score
    end
  end
  prediction = match.predictions.find_by(user: @user)
  if prediction.present?
    json.prediction do
      json.id prediction.id
      json.choice prediction.choice
      json.user_id prediction.user_id
      json.match_id prediction.match_id
    end
  end
end

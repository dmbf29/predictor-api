json.array! @matches do |match|
  json.extract! match, :id, :kickoff_time, :status, :group_id, :next_match_id, :round_id
  json.team_home do
    json.partial! match.team_home
    json.score match.team_home_score if match.finished?
  end
  json.team_away do
    json.partial! match.team_away
    json.score match.team_away_score if match.finished?
  end
  user_prediction = @predictions.where(match: match).find_by(user: @user)
  json.prediction { json.partial! user_prediction } if user_prediction
end

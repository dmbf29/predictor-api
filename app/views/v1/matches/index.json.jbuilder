json.array! @matches do |match|
  json.extract! match, :id, :kickoff_time, :team_home_score, :team_away_score, :status, :group_id, :team_away_id, :team_home_id, :next_match_id, :round_id
  prediction = match.predictions.find_by(user: @user)
  if prediction
    json.prediction do
      json.id prediction.id
      json.choice prediction.choice
      json.user_id prediction.user.id
      json.match_id prediction.match.id
    end
  end
end

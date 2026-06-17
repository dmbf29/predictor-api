json.partial! @user
if @competition
  user_score = @user.scores.find_by(competition: @competition)
  json.points user_score&.score || 0
  json.accuracy (user_score&.accuracy || 0).to_f
  json.possible_points @competition.max_possible_score
end

json.partial! @user
if @competition
  json.points @user.scores.find_by(competition: @competition).score
  json.accuracy @user.scores.find_by(competition: @competition).accuracy.to_f
  json.possible_points @competition.max_possible_score
end

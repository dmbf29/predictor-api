json.partial! @user
json.points @user.scores.where(competition: @competition).score if @competition
json.possible_points @competition.max_possible_score if @competition

json.partial! @user
json.points @user.scores.find_by(competition: @competition).score if @competition
json.possible_points @competition.max_possible_score if @competition

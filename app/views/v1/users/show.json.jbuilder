json.partial! @user
json.points @user.score(@competition) if @competition
json.possible_points @user.possible_score(@competition) if @competition

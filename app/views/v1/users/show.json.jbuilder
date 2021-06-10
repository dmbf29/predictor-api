json.partial! @user
json.points @user.score(@competition) if @competition

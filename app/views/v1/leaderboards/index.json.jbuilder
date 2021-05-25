json.array! @leaderboards do |leaderboard|
  json.extract! leaderboard, :id, :name, :password, :user_id, :competition_id
end

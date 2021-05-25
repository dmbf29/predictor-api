json.array! @leaderboards do |leaderboard|
  json.partial! leaderboard
  json.users leaderboard.users do |user|
    json.user_id user.id
    json.points user.predictions.count(&:correct?) * 3
  end
end

# TODO: add 🔼 or 🔽
# TODO: user predictions should be scoped by competition

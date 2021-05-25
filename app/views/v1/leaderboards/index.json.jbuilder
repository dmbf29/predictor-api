json.array! @leaderboards do |leaderboard|
  json.partial! leaderboard
  json.users leaderboard.users do |user|
    json.user_id user.id
    json.name user.display_name
    json.points user.score(leaderboard.competition)
  end
end

# TODO: add 🔼 or 🔽

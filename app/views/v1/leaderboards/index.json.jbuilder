json.array! @leaderboards do |leaderboard|
  json.partial! 'v1/leaderboards/leaderboard', leaderboard: leaderboard
  json.users leaderboard.users do |user|
    json.user_id user.id
    json.name user.display_name
    json.points user.score(leaderboard.competition)
    json.photo_key user.photo_key
  end
  json.results do
    results = leaderboard.locked_predictions.order('matches.kickoff_time DESC').group_by(&:match_id).transform_values do |match_predictions|
      match_predictions.group_by(&:choice).transform_values! { |c| c.map(&:user_id) }
    end
    json.merge! results
  end
end

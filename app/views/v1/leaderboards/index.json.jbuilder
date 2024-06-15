json.array! @leaderboards do |leaderboard|
  json.partial! leaderboard
  rankings = leaderboard.rankings.order(:user_rank)
  json.users rankings do |ranking|
    json.partial! 'v1/leaderboards/ranking', ranking: ranking
  end
  json.results do
    leaderboard.match_results.each do |result|
      json.partial! 'v1/leaderboards/predictions', result: result
    end
  end
end

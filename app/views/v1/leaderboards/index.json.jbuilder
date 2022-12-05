json.array! @leaderboards do |leaderboard|
  json.partial! 'v1/leaderboards/leaderboard', leaderboard: leaderboard
  json.users leaderboard.rankings do |ranking|
    json.partial! 'v1/leaderboards/ranking', ranking: ranking
  end
  json.results do
    leaderboard.match_results.each do |result|
      json.partial! 'v1/matches/result', result: result
    end
  end
end

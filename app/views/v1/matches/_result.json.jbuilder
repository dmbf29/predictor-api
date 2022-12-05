json.set! result.match_id do
  json.home result.predicted_home
  json.draw result.predicted_draw
  json.away result.predicted_away
end
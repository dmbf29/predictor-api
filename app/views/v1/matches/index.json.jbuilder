json.array! @matches do |match|
  json.partial! match
  json.prediction do
    prediction = match.predictions.find_by(user: @user)
    json.partial! prediction if prediction.present?
  end
end

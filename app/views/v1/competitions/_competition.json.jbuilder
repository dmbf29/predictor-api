json.extract! competition, :id, :name, :start_date, :end_date, :current_round_id
json.photo_url cl_image_path(competition.photo.key) if competition.photo.attached?

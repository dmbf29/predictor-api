json.extract! user, :id, :name, :email, :timezone, :admin
json.photo_key user.photo.key if user.photo.attached?

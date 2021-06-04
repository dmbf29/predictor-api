json.extract! user, :id, :name, :email, :timezone, :admin
json.photo_url cl_image_path(user.photo.key) if user.photo.attached?

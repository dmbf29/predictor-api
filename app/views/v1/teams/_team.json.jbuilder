json.extract! team, :id, :name, :abbrev
json.badge_url cl_image_path(team.badge.key) if team.badge.attached?
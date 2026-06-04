json.extract! team, :id, :name, :abbrev, :ranking
json.badge_url cl_image_path(team.badge.key) if team.badge.attached?
json.flag_url cl_image_path(team.flag.key) if team.flag.attached?

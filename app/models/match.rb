class Match < ApplicationRecord
  belongs_to :group
  belongs_to :team_away
  belongs_to :team_home
  belongs_to :next_match
end

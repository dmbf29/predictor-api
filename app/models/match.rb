class Match < ApplicationRecord
  belongs_to :team_away, class_name: 'Team'
  belongs_to :team_home, class_name: 'Team'
  belongs_to :group, optional: true
  belongs_to :next_match, class_name: 'Match', optional: true
  has_many :predictions
  has_many :users, through: :predictions
end

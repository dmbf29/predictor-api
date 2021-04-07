class Team < ApplicationRecord
  has_many :affiliations
  has_many :groups, through: :affiliations
  validates :name, presence: true, uniqueness: true
  validates :abbrev, presence: true, uniqueness: true

  def matches
    Match.where('team_home_id = ? OR team_away_id = ?', id, id)
  end
end

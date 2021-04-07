class Team < ApplicationRecord
  has_many :affiliations, dependent: :destroy
  has_many :groups, through: :affiliations
  validates :name, presence: true, uniqueness: true
  validates :abbrev, presence: true, uniqueness: true

  def matches
    # teams can either be home or away
    Match.where('team_home_id = ? OR team_away_id = ?', id, id)
  end
end

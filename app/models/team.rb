class Team < ApplicationRecord
  has_many :affiliations, dependent: :destroy
  has_many :groups, through: :affiliations
  validates :name, presence: true, uniqueness: true
  validates :abbrev, presence: true, uniqueness: true
  has_one_attached :badge

  def matches
    # teams can either be home or away
    Match.where('team_home_id = :id OR team_away_id = :id', id: id)
  end
end

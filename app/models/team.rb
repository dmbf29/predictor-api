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

  # These methods are not used for Group rankings, but could be used for individual team stats
  def victories
    matches.finished.where(<<-SQL, id: id)
      (team_home_id = :id AND team_home_score > team_away_score) OR
      (team_away_id = :id AND team_home_score < team_away_score)
    SQL
  end

  def defeats
    matches.finished.where(<<-SQL, id: id)
      (team_home_id = :id AND team_home_score < team_away_score) OR
      (team_away_id = :id AND team_home_score > team_away_score)
    SQL
  end

  def draws
    matches.finished.where(<<-SQL, id: id)
      (team_home_id = :id OR team_away_id = :id) AND
      team_home_score = team_away_score
    SQL
  end
end

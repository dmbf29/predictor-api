class Affiliation < ApplicationRecord
  belongs_to :team
  belongs_to :group
  validates_uniqueness_of :team, scope: :group

  def points
    victories.count * 3 + draws.count
  end

  def goal_diff
    victories.sum('ABS(team_home_score - team_away_score)') - defeats.sum('ABS(team_home_score - team_away_score)')
  end

  private

  def victories
    team.victories.where(group: group)
  end

  def defeats
    team.defeats.where(group: group)
  end

  def draws
    team.draws.where(group: group)
  end
end

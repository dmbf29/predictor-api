class Affiliation < ApplicationRecord
  belongs_to :team
  belongs_to :group
  validates_uniqueness_of :team, scope: :group

  def points
    # Could probably be optimized into a single query
    team.victories.count * 3 + team.draws.count
  end

  def goal_diff
    # TODO
  end
end

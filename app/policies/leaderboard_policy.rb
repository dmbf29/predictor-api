class LeaderboardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.leaderboards
    end
  end

  def create?
    true
  end

  def destroy?
    record.user == user || record.memberships.find_by(user: user)
  end
end

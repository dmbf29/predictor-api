class LeaderboardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def create?
    true
  end

  def destroy?
    record.user == user || record.memberships.find_by(user: user)
  end
end

class PredictionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:match).where(user: user).or(
        scope.joins(:match).where.not(user: user).where.not(matches: { status: :upcoming })
      ).distinct
    end
  end

  def create?
    true
  end

  def update?
    owner_or_admin?
  end

  private

  def owner_or_admin?
    record.user == user || user.admin?
  end
end

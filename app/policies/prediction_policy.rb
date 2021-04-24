class PredictionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
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

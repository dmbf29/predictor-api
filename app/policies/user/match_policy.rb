class User::MatchPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.matches
    end
  end
end

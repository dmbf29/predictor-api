module Auth
  module DeviseTokenAuth
    class RegistrationsController < ::DeviseTokenAuth::RegistrationsController
      after_action :auto_join_leaderboards, only: :create

      private

      def auto_join_leaderboards
        Leaderboard.auto_join.each do |leaderboard|
          leaderboard.memberships.create(user: @resource)
        end
      end
    end
  end
end

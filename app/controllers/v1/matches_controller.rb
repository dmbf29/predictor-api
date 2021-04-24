class V1::MatchesController < ApplicationController

  # /matches?competition_id=:id&user_id=:id
  def index
    @user = User.find_by(id: params[:user_id]) || current_user
    @competition = Competition.find_by(id: params[:competition_id])
    @matches =
      if @competition
        policy_scope(Match).where(group: @competition.groups).order(:kickoff_time)
      else
        policy_scope([:user, Match]).order(:kickoff_time)
      end
  end
end

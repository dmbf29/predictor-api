class V1::MatchesController < ApplicationController
  # /matches?competition_id=:id&user_id=:id
  def index
    @user = User.find_by(id: params[:user_id]) || current_user
    # TODO: Why is the FE sending competition_id: '1'???
    # p @competition = Competition.find_by(id: params[:competition_id])
    @competition = Competition.order(id: :desc).first
    skip_policy_scope
    @matches = @user.matches(competition: @competition)
  end
end

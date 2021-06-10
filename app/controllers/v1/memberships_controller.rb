class V1::MembershipsController < ApplicationController
  def create
    @leaderboard = Leaderboard.find_by(password: params[:password])
    membership = Membership.new(user: current_user, leaderboard: @leaderboard)
    authorize membership
    if (@membership = Membership.where(user: current_user, leaderboard: @leaderboard).first_or_create)
      render :show, status: :created
    else
      render_error(@membership)
    end
  end
end

class V1::MembershipsController < ApplicationController
  def create
    @leaderboard = Leaderboard.find_by(password: params[:password])
    @membership = Membership.find_or_initialize_by(user: current_user, leaderboard: @leaderboard)
    authorize @membership
    if @membership.save
      render :show, status: :created
    else
      render_error(@membership)
    end
  end
end

class V1::MembershipsController < ApplicationController
  def create
    @leaderboard = Leaderboard.find_by(password: params[:password])
    @membership = Membership.new
    @membership.leaderboard = @leaderboard
    @membership.user = current_user
    authorize @membership
    if @membership.save
      render 'leaderboards/show', status: :created
    else
      render_error(@membership)
    end
  end
end

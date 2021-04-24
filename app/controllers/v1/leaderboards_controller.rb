class V1::LeaderboardsController < ApplicationController

  def create
    @competition = Competition.find(params[:competition_id])
    @leaderboard = Leaderboard.new(leaderboard_params)
    @leaderboard.competition = @competition
    @leaderboard.user = current_user
    authorize @prediction
    if @leaderboard.save
      render :show, status: :created
    else
      render_error(@leaderboard)
    end
  end

  private

  def leaderboard_params
    params.require(:leaderboard).permit(:name)
  end

end

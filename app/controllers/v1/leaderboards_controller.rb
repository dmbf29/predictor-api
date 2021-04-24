class V1::LeaderboardsController < ApplicationController

  def create
    @match = Match.find(params[:match_id])
    @prediction = Prediction.new(prediction_params)
    @prediction.match = @match
    @prediction.user = current_user
    authorize @prediction
    if @leaderboard.save
      render :show, status: :created
    else
      render_error(@leaderboard)
    end
  end

  private

  def leaderboard_params
    params.require(:leaderboard).permit(:)
  end

end

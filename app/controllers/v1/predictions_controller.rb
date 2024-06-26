class V1::PredictionsController < ApplicationController
  def create
    @match = Match.upcoming.find(params[:match_id])
    @prediction = Prediction.new(prediction_params)
    @prediction.match = @match
    @prediction.user = current_user
    authorize @prediction
    if @prediction.save
      render :show, status: :created
    else
      render_error(@prediction)
    end
  end

  def update
    @prediction = Prediction.editable.find_by(user: current_user, match: params[:match_id])
    authorize @prediction
    if @prediction.update(prediction_params)
      render :show
    else
      render_error(@prediction)
    end
  end

  private

  def prediction_params
    params.require(:prediction).permit(:choice)
  end
end

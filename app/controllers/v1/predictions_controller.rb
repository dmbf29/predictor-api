class V1::PredictionsController < ApplicationController

  def create
    @match = Match.find(params[:match_id])
    @predition = Predicition.new(prediction_params)
    @prediction.match = @match
    @prediction.user = current_user
    if @prediction.save
      render :show, status: :created
    else
      render_error
    end
  end

  def update
    @predition = Predicition.find_by(user: current_user, match: params[:match_id])
    if @prediction.update(prediction_params)
      render :show
    else
      render_error
    end
  end

  private

  def prediction_params
    params.require(:prediction).permit(:choice)
  end

  def render_error
    render json: { errors: @prediction.errors.full_messages },
      status: :unprocessable_entity
  end
end
require 'open-uri'

class V1::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @competition = Competition.find(params[:competition_id]) if params[:competition_id]
    authorize @user
  end

  def update
    @user = current_user
    authorize @user

    if @user.update(prediction_params)
      render :show
    else
      render_error(@user)
    end
  end

  private

  def prediction_params
    params.require(:user).permit(:name, :timezone, :photo_key, preferences: {})
  end
end

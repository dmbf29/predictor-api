class V1::UsersController < ApplicationController
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
    params.require(:user).permit(:name, :timezone)
  end
end

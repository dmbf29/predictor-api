require 'open-uri'

class V1::UsersController < ApplicationController
  def update
    @user = current_user
    authorize @user

    if params[:user][:photo_url]
      file = URI.open(params[:user][:photo_url])
      @user.photo.attach(io: file, filename: 'profile.png', content_type: 'image/png')
      render :show
    elsif @user.update(prediction_params)
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

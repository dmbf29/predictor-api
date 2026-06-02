class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.prediction_missing.subject
  #
  def prediction_missing
    @user = params[:user]
    @round = params[:round]
    @missing_count = params[:missing_count]
    @notification = params[:notification]
    mail(to: @user.email, subject: "Octacle - You're missing #{@missing_count} prediction#{'s' if @missing_count != 1} in #{@round.name}")
    Email.create(user: @user, topic: @round, notification: @notification)
  end
end

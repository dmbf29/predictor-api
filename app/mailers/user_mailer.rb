class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.prediction_missing.subject
  #
  def prediction_missing
    @user = params[:user] # Instance variable => available in view
    @match = params[:match]
    @notification = params[:notification]
    mail(to: @user.email, subject: "Octacle - Make your predictions before it's too late!")
    Email.create(user: @user, match: @match, notification: @notification)
  end
end

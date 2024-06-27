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
    mail(to: @user.email, subject: "Octacle - You're missing a prediction for #{@match.team_home.abbrev} vs. #{@match.team_away.abbrev}")
    Email.create(user: @user, topic: @match, notification: @notification)
  end
end

class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.prediction_missing.subject
  #
  def match_missing
    @user = params[:user]
    mail(to: @user.email, subject: "Octacle - You're missing some predictions")
  end

  def prediction_missing
    @user = params[:user]
    @round = params[:round]
    @matchday = params[:matchday]
    @missing_count = params[:missing_count]
    @notification = params[:notification]
    stage_label = @matchday ? "#{@round.name} - Matchday #{@matchday}" : @round.name
    mail(to: @user.email, subject: "Octacle - You're missing #{@missing_count} prediction#{'s' if @missing_count != 1} in #{stage_label}")
    Email.create(user: @user, topic: @round, notification: @notification)
  end
end

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/prediction_missing
  def prediction_missing
    user = User.first
    round = Round.first
    UserMailer.with(user: user, round: round, matchday: 1, missing_count: 2, notification: nil).prediction_missing
  end

end

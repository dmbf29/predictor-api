require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "prediction_missing" do
    user = users(:one)
    round = rounds(:one)
    mail = UserMailer.with(user: user, round: round, matchday: 1, missing_count: 2, notification: nil).prediction_missing
    assert_equal "Octacle - You're missing 2 predictions in #{round.name} - Matchday 1", mail.subject
    assert_equal [user.email], mail.to
  end
end

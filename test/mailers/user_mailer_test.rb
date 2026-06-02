require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "prediction_missing" do
    mail = UserMailer.prediction_missing
    assert_equal "Prediction missing", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

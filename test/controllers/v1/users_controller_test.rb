require "test_helper"

class V1::UsersControllerTest < ActionDispatch::IntegrationTest
  # Opt out of the shared fixtures (currently stale vs the schema) and build our own
  # minimal data, so this regression test is self-contained.
  self.fixture_table_names = []

  # Regression: GET /v1/users/:id?competition_id=X used to 500 (NoMethodError on nil)
  # when the user had no UserScore row for that competition. See show.json.jbuilder.
  test "show with competition_id succeeds when user has no scores" do
    user = User.create!(email: "noscores@example.test", password: "password123")
    competition = Competition.create!(
      name: "Regression Cup", start_date: Date.today, end_date: Date.today + 30
    )
    auth_headers = user.create_new_auth_token

    get v1_user_url(user), params: { competition_id: competition.id }, headers: auth_headers

    assert_response :success         # previously raised NoMethodError -> 500
    body = JSON.parse(response.body)
    assert_equal 0, body["points"]   # no UserScore row -> defaults to 0
    assert_equal 0.0, body["accuracy"]
  end
end

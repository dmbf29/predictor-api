class V1::MatchesController < ApplicationController
  # /matches?competition_id=:id&user_id=:id
  def index
    @user = User.find_by(id: params[:user_id]) || current_user
    competition = Competition.find_by(id: params[:competition_id])
    @matches = policy_scope(Match).includes(
      :round,
      team_home: [badge_attachment: :blob, flag_attachment: :blob],
      team_away: [badge_attachment: :blob ,flag_attachment: :blob]
    ).where(competition: competition)
  end
end

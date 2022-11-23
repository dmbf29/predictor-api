class V1::LeaderboardsController < ApplicationController
  def index
    @competition = Competition.find(params[:competition_id])
    @leaderboards = policy_scope(Leaderboard).includes(:users, locked_predictions: { match: { group: :round } })
                                             .where(competition: @competition)
  end

  def create
    @competition = Competition.find(params[:competition_id])
    @leaderboard = Leaderboard.new(leaderboard_params)
    @leaderboard.competition = @competition
    @leaderboard.user = current_user
    authorize @leaderboard
    if @leaderboard.save
      render :show, status: :created
    else
      render_error(@leaderboard)
    end
  end

  def destroy
    @leaderboard = Leaderboard.find(params[:id])
    authorize @leaderboard
    membership = @leaderboard.memberships.find_by!(user: current_user)
    membership.destroy
    head :no_content
  end

  private

  def leaderboard_params
    params.require(:leaderboard).permit(:name)
  end
end

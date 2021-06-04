class V1::MatchesController < ApplicationController
  # /matches?competition_id=:id&user_id=:id
  def index
    @user = User.find_by(id: params[:user_id]) || current_user
    @competition = Competition.find_by(id: params[:competition_id])
    @matches =
      if @competition
        policy_scope(Match).joins(:team_away, :team_home)
                           .left_outer_joins(:predictions)
                           .includes(:team_away, :team_home, :predictions)
                           .where(group: @competition.groups)

        # TODO: Rewrite the query to avoid iterating over each match to get the predictions

        # # ORIGINAL ATTEMPT
        # # The following query doesn't work because if any use makes a prediction on a match,
        # # the predictions.user_id in the joined table is neither the current user's id, nor
        # # is it NULL. The solution would be to make a SQL UNION query (not possible in AR).
        # policy_scope(Match).joins(:team_away, :team_home)
        #                    .left_outer_joins(:predictions)
        #                    .includes(:team_away, :team_home, :predictions)
        #                    .where(group: @competition.groups)
        #                    .where('predictions.user_id = ? OR predictions.user_id IS NULL', @user.id)
        #                    .order(:kickoff_time)

        # # NEW ATTEMPT
        # matches_with_predictions = policy_scope(Match).joins(:team_away, :team_home)
        #                                               .joins(:predictions)
        #                                               .includes(:team_away, :team_home, :predictions)
        #                                               .where(group: @competition.groups)
        #                                               .where('predictions.user_id = ?', @user.id)

        # matches_without_predictions = policy_scope(Match).joins(:team_away, :team_home)
        #                                                  .includes(:team_away, :team_home, :predictions)
        #                                                  .where(group: @competition.groups)
        #                                                  .where.not(matches: { id: matches_with_predictions })

        # sql_query = "(#{matches_with_predictions.to_sql}) UNION (#{matches_without_predictions.to_sql})"
        # policy_scope(Match).execute_sql(sql_query)
      else
        policy_scope([:user, Match]).order(:kickoff_time)
      end
  end
end

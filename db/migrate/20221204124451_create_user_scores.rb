class CreateUserScores < ActiveRecord::Migration[6.1]
  def change
    create_view :user_scores
  end
end

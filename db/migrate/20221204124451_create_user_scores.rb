class CreateUserScores < ActiveRecord::Migration[6.1]
  def change
    create_view :user_scores, materialized: true
  end
end

class AddMoreScoresToMatches < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :team_home_et_score, :integer
    add_column :matches, :team_away_et_score, :integer
    add_column :matches, :team_home_ps_score, :integer
    add_column :matches, :team_away_ps_score, :integer
  end
end

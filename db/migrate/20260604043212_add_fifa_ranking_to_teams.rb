class AddFifaRankingToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :ranking, :integer
  end
end

class AddCurrentRoundToCompetitions < ActiveRecord::Migration[6.1]
  def change
    add_reference :competitions, :current_round, foreign_key: { to_table: :rounds }
    add_reference :matches, :next_match, foreign_key: { to_table: :matches }
  end
end

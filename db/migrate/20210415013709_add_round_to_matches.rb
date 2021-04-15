class AddRoundToMatches < ActiveRecord::Migration[6.1]
  def change
    add_reference :matches, :round, null: true, foreign_key: true
    change_column_null :matches, :group_id, true
  end
end

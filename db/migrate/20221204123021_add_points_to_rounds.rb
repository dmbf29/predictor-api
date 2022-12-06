class AddPointsToRounds < ActiveRecord::Migration[6.1]
  def up
    add_column :rounds, :points, :integer

    Round.find_each do |round|
      round.update_columns(points: round.number + 2)
    end

    change_column_null :rounds, :points, false
  end

  def down
    remove_column :rounds, :points
  end
end

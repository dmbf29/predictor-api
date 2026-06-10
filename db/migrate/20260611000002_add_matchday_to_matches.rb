class AddMatchdayToMatches < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :matchday, :integer
  end
end

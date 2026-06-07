class AddMinuteToMatches < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :minute, :integer
  end
end

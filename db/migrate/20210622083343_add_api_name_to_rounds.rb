class AddApiNameToRounds < ActiveRecord::Migration[6.1]
  def change
    add_column :rounds, :api_name, :string
  end
end

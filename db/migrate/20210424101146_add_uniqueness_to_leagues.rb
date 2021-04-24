class AddUniquenessToLeagues < ActiveRecord::Migration[6.1]
  def change
    change_column :leaderboards, :password, :string, unique: true
  end
end

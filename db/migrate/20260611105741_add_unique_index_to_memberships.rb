class AddUniqueIndexToMemberships < ActiveRecord::Migration[6.1]
  def change
    add_index :memberships, [:leaderboard_id, :user_id], unique: true
  end
end

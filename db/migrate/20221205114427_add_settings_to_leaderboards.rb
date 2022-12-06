class AddSettingsToLeaderboards < ActiveRecord::Migration[6.1]
  def change
    add_column :leaderboards, :auto_join, :boolean, null: false, default: false
    add_column :leaderboards, :leave_disabled, :boolean, null: false, default: false
    add_column :leaderboards, :rankings_top_n, :integer
  end
end

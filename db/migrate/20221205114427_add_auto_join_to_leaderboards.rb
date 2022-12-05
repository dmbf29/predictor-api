class AddAutoJoinToLeaderboards < ActiveRecord::Migration[6.1]
  def change
    add_column :leaderboards, :auto_join, :boolean, default: false
  end
end

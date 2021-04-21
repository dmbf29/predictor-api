class ChangeLeaguesToLeaderboards < ActiveRecord::Migration[6.1]
  def change
    rename_table :leagues, :leaderboards
  end
end

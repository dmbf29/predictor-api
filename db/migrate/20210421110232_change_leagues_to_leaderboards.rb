class ChangeLeaguesToLeaderboards < ActiveRecord::Migration[6.1]
  def change
    remove_reference :memberships, :league, index: true, foreign_key: true
    rename_table :leagues, :leaderboards
    add_reference :memberships, :leaderboard, foreign_key: true
  end
end

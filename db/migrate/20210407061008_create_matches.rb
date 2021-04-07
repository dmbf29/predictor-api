class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.datetime :kickoff_time
      t.integer :team_home_score
      t.integer :team_away_score
      t.integer :status
      t.references :group, null: false, foreign_key: true
      t.references :team_away, foreign_key: { to_table: :teams }
      t.references :team_home, foreign_key: { to_table: :teams }
      t.references :next_match, foreign_key: { to_table: :match }

      t.timestamps
    end
  end
end

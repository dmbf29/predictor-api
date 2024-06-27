class CreateEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :emails do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification
      t.references :topic, polymorphic: true
      t.timestamps
    end
  end
end

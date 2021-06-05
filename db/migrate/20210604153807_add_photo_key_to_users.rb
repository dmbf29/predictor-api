class AddPhotoKeyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :photo_key, :string
  end
end

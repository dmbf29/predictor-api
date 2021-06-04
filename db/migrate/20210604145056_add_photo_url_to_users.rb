class AddPhotoUrlToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :photo_url, :string
  end
end

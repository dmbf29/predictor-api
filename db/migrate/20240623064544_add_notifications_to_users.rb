class AddNotificationsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :notifications, :jsonb, default: {}
    add_index :users, :notifications, using: :gin
    User.find_each do |user|
      user.notifications = {
        email: {
          prediction_missing: true,
          competition_new: true
        }
      }
      user.save
    end
  end
end

class ChangeNotificationsDefaultForUsers < ActiveRecord::Migration[6.1]
  def up
    change_column_default :users, :notifications, from: {}, to: { email: { competition_new: false, prediction_missing: true } }
    execute <<~SQL
      UPDATE users
      SET notifications = jsonb_set(COALESCE(notifications, '{}'::jsonb), '{email,prediction_missing}', 'true'::jsonb)
      WHERE notifications->'email'->>'prediction_missing' IS NULL
         OR notifications IS NULL
    SQL
  end

  def down
    change_column_default :users, :notifications, from: { email: { competition_new: false, prediction_missing: true } }, to: {}
  end
end

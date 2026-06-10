class BackfillEmailPredictionMissingForUsers < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      UPDATE users
      SET notifications = jsonb_set(
        jsonb_set(
          COALESCE(notifications, '{}'::jsonb),
          '{email}',
          COALESCE(notifications->'email', '{}'::jsonb)
        ),
        '{email,prediction_missing}',
        'true'::jsonb
      )
      WHERE notifications IS NULL
         OR notifications->'email'->>'prediction_missing' IS NULL
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

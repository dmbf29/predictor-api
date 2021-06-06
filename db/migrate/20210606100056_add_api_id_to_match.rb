class AddApiIdToMatch < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :api_id, :integer
    MatchUpdateJob.perform_now
  end
end

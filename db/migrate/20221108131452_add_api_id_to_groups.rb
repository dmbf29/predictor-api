class AddApiIdToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :api_id, :integer
  end
end

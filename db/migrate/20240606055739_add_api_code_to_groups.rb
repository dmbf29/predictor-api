class AddApiCodeToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :api_code, :string
  end
end

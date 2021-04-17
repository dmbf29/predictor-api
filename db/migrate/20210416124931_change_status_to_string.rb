class ChangeStatusToString < ActiveRecord::Migration[6.1]
  def up
    change_column :matches, :status, :string, default: nil
  end

  def down
    change_column :matches, :status, :integer, using: 'status::integer', default: 0
  end
end

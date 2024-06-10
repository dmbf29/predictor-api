class AddApiCodeToCompetitions < ActiveRecord::Migration[6.1]
  def change
    add_column :competitions, :api_code, :string
  end
end

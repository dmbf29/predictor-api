class CreateMatchResults < ActiveRecord::Migration[6.1]
  def change
    create_view :match_results
  end
end

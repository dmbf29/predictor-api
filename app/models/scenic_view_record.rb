class ScenicViewRecord < ApplicationRecord
  self.abstract_class = true
  
  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end

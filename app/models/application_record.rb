class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  def self.execute_sql(query, args = {})
    query = sanitize_sql([query, args])
    results = ActiveRecord::Base.connection.execute(query)
    return unless results.present?

    results
  end

  def refresh_materialized_views
    DatabaseViews.refresh(async: true)
  end
end

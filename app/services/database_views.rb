class DatabaseViews
  MODELS = [Membership, Leaderboard, Competition, Match, Prediction, Round]

  def self.refresh(async: true)
    async ? RefreshDatabaseViewsJob.perform_later : RefreshDatabaseViewsJob.perform_now
  end

  def self.deactivate_callback
    MODELS.each do |model|
      model.skip_callback(:commit, :after, :refresh_materialized_views)
    end
  end

  def self.activate_callback(then_refresh: false)
    MODELS.each do |model|
      model.set_callback(:commit, :after, :refresh_materialized_views)
    end
    refresh if then_refresh
  end

  def self.run_without_callback(then_refresh: false, &block)
    deactivate_callback
    yield
    activate_callback(then_refresh: then_refresh)
  end
end

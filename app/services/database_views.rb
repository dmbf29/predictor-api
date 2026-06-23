class DatabaseViews
  MODELS = [Membership, Leaderboard, Competition, Match, Prediction, Round]

  def self.refresh(async: true)
    async ? RefreshDatabaseViewsJob.perform_later : RefreshDatabaseViewsJob.perform_now
  end

  def self.deactivate_callback
    Thread.current[:skip_refresh_materialized_views] = true
  end

  def self.activate_callback(then_refresh: false)
    Thread.current[:skip_refresh_materialized_views] = false
    refresh if then_refresh
  end

  def self.run_without_callback(then_refresh: false, &block)
    previous = Thread.current[:skip_refresh_materialized_views]
    Thread.current[:skip_refresh_materialized_views] = true
    completed = false
    begin
      yield
      completed = true
    ensure
      Thread.current[:skip_refresh_materialized_views] = previous
      refresh if completed && then_refresh
    end
  end
end

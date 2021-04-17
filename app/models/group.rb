class Group < ApplicationRecord
  belongs_to :round
  has_many :matches, dependent: :destroy
  has_many :affiliations, dependent: :destroy
  has_many :teams, through: :affiliations
  validates :name, presence: true
  validates_uniqueness_of :name, scope: :round

  RANKING_SQL = <<-SQL.freeze
    WITH match_results AS (
      SELECT teams.id AS team_id, matches.id AS match_id,
      CASE -- Calculating points earned per match
        WHEN
          (team_home_id = teams.id AND team_home_score > team_away_score)
          OR (team_away_id = teams.id AND team_home_score < team_away_score)
        THEN 3
        WHEN
          (team_home_id = teams.id AND team_home_score < team_away_score) OR
          (team_away_id = teams.id AND team_home_score > team_away_score)
        THEN 0
        ELSE 1
      END AS result,
      CASE -- Calculating goal difference
        WHEN team_home_id = teams.id THEN team_home_score - team_away_score
        ELSE team_away_score - team_home_score
      END AS match_goal_diff
      FROM teams
      JOIN matches ON team_home_id = teams.id OR team_away_id = teams.id
      WHERE status = 'finished' AND group_id = :group_id
    )
    SELECT teams.*, SUM(result) AS points, SUM(match_goal_diff) AS goal_diff, COUNT(*) AS matches_count
    FROM match_results
    JOIN teams ON team_id = teams.id
    GROUP BY teams.id
    ORDER BY points DESC, goal_diff DESC
  SQL

  def ranking
    Group.execute_sql(RANKING_SQL, group_id: id)
  end

  def leader
    Team.find(ranking.first['id'])
  end

  def runner_up
    Team.find(ranking[1]['id'])
  end
end

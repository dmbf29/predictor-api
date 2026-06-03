WITH unique_members AS (
  SELECT DISTINCT leaderboard_id, user_id
  FROM memberships
)
SELECT
  l.id AS leaderboard_id,
  um.user_id,
  l.competition_id,
  COALESCE(us.score, 0) AS score,
  COALESCE(us.max_possible_score, 0) AS max_possible_score,
  COALESCE(us.total_predictions, 0) AS total_predictions,
  COALESCE(us.completed_predictions, 0) AS completed_predictions,
  COALESCE(us.correct_predictions, 0) AS correct_predictions,
  COALESCE(us.accuracy, 0) AS accuracy,
  RANK() OVER (
    PARTITION BY l.id
    ORDER BY
      COALESCE(us.score, 0) DESC,
      COALESCE(us.accuracy, 0) DESC,
      COALESCE(us.completed_predictions, 0) DESC
  ) AS user_rank
FROM leaderboards l
JOIN unique_members um ON um.leaderboard_id = l.id
LEFT JOIN user_scores us ON us.user_id = um.user_id AND us.competition_id = l.competition_id
ORDER BY l.id, um.user_id

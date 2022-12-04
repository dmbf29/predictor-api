SELECT
	l.id AS leaderboard_id,
	l.competition_id,
	us.user_id,
	us.score,
	us.accuracy,
	us.completed_predictions,
	RANK () OVER (
		PARTITION BY l.id
		ORDER BY us.score DESC, us.accuracy DESC, us.completed_predictions DESC
	) user_rank
FROM leaderboards l 
JOIN user_scores us ON us.competition_id = l.competition_id 
GROUP BY l.id, us.user_id, us.score, us.accuracy, us.completed_predictions

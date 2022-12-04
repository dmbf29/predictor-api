WITH prediction_scores AS (
	SELECT
		p.id AS prediction_id,
		(
			CASE
			WHEN mr.status = 'finished' AND p.choice IS NOT NULL THEN TRUE
			ELSE FALSE
			END
		) AS completed,
		(
			CASE
			WHEN mr.status = 'finished' AND p.choice = mr.winning_side THEN TRUE
			ELSE FALSE
			END
		) AS correct,
		(
			CASE
			WHEN mr.status = 'finished' AND p.choice = mr.winning_side THEN mr.points
			ELSE 0
			END
		) AS prediction_score
	FROM predictions p
	LEFT JOIN match_results mr ON mr.match_id = p.match_id
)
SELECT
	u.id AS user_id,
	mr.competition_id,
	SUM(ps.prediction_score) AS score,
	COUNT(ps.prediction_id) AS total_predictions,
	COUNT(CASE WHEN ps.completed THEN 1 END) AS completed_predictions,
	COUNT(CASE WHEN ps.correct THEN 1 END) AS correct_predictions,
	(
		CASE
		WHEN COUNT(CASE WHEN ps.completed THEN 1 END) > 0 THEN COUNT(CASE WHEN ps.correct THEN 1 END) * 1.0 / COUNT(CASE WHEN ps.completed THEN 1 END)
		ELSE NULL 
		END
	) AS accuracy
FROM users u 
LEFT JOIN predictions p ON p.user_id = u.id 
LEFT JOIN prediction_scores ps ON ps.prediction_id = p.id
LEFT JOIN match_results mr ON mr.match_id  = p.match_id
GROUP BY u.id, mr.competition_id
ORDER BY u.id

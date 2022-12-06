WITH prediction_scores AS (
	SELECT
		DISTINCT p.id AS prediction_id,
		p.user_id,
		p.match_id,
		r.points,
		mr.competition_id,
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
	LEFT JOIN rounds r ON r.id = mr.round_id
), prediction_numbers AS (
	SELECT
		u.id AS user_id,
		ps.competition_id,
		SUM(ps.prediction_score) AS score,
		COUNT(DISTINCT ps.prediction_id) AS total_predictions,
		(
			SELECT COUNT(DISTINCT ps2.prediction_id)
			FROM prediction_scores ps2
			WHERE ps2.completed IS TRUE
			GROUP BY ps2.user_id, ps2.competition_id
			HAVING ps2.user_id = u.id AND ps2.competition_id = ps.competition_id
		) AS completed_predictions,
		(
			SELECT COUNT(DISTINCT ps2.prediction_id)
			FROM prediction_scores ps2
			WHERE ps2.correct IS TRUE
			GROUP BY ps2.user_id, ps2.competition_id
			HAVING ps2.user_id = u.id AND ps2.competition_id = ps.competition_id
		) AS correct_predictions
	FROM users u
	LEFT JOIN prediction_scores ps ON ps.user_id = u.id
	GROUP BY u.id, ps.competition_id
)
SELECT DISTINCT ON (ps.user_id, ps.competition_id)
	ps.user_id,
	ps.competition_id,
	pn.score,
	pn.completed_predictions * ps.points AS max_possible_score,
	pn.total_predictions,
	pn.completed_predictions,
	pn.correct_predictions,
	ROUND(pn.correct_predictions * 1.0 / NULLIF(pn.total_predictions, 0), 3) AS accuracy
FROM prediction_scores ps
JOIN prediction_numbers pn ON pn.user_id = ps.user_id AND pn.competition_id = ps.competition_id
ORDER BY ps.user_id

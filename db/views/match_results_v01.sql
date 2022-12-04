WITH match_rounds AS (
	SELECT
		m.id AS match_id,
		(
			CASE
				WHEN m.round_id IS NOT NULL THEN m.round_id
				ELSE g.round_id
			END
		) AS round_id
	FROM
		matches m
		LEFT JOIN groups g ON m.group_id = g.id
		LEFT JOIN rounds r ON m.round_id = r.id
)
SELECT
	m.id AS match_id,
	m.group_id,
	r.id AS round_id,
	r.competition_id,
	m.kickoff_time,
	m.team_home_score,
	m.team_away_score,
	m.status,
	m.team_away_id,
	m.team_home_id,
	m.created_at,
	m.updated_at,
	m.next_match_id,
	m.api_id,
	m.location,
	m.team_home_et_score,
	m.team_away_et_score,
	m.team_home_ps_score,
	m.team_away_ps_score,
	(
		CASE
			WHEN (
				status = 'upcoming'
				OR status = 'started'
			) THEN NULL
			WHEN (
				team_home_score = team_away_score
				AND team_home_et_score = team_away_et_score
				AND team_home_ps_score = team_away_ps_score
			) THEN 'draw'
			WHEN (
				team_home_score > team_away_score
				OR (
					team_home_et_score IS NOT NULL
					AND team_home_et_score > team_away_et_score
				)
				OR (
					team_home_ps_score IS NOT NULL
					AND team_home_ps_score > team_away_ps_score
				)
			) THEN 'home'
			ELSE 'away'
		END
	) AS winning_side,
	(
		CASE
			WHEN (
				status = 'upcoming'
				OR status = 'started'
			) THEN NULL
			WHEN (
				team_home_score = team_away_score
				AND team_home_et_score = team_away_et_score
				AND team_home_ps_score = team_away_ps_score
			) THEN NULL
			WHEN (
				team_home_score > team_away_score
				OR (
					team_home_et_score IS NOT NULL
					AND team_home_et_score > team_away_et_score
				)
				OR (
					team_home_ps_score IS NOT NULL
					AND team_home_ps_score > team_away_ps_score
				)
			) THEN team_home_id
			ELSE team_away_id
		END
	) AS winner_id,
	r.number AS round_number,
	r.points AS points,
	r.name AS round_name
FROM
	matches m
	JOIN match_rounds mr ON mr.match_id = m.id
	JOIN rounds r ON mr.round_id = r.id
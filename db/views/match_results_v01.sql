WITH leaderboard_users AS (
	SELECT
		leaderboards.id,
		mb.user_id
	FROM leaderboards
	JOIN memberships mb ON mb.leaderboard_id = leaderboards.id
)
SELECT
	matches.id AS match_id,
	matches.round_id,
	matches.competition_id,
	l.id AS leaderboard_id,
	matches.status,
	matches.group_id,
	matches.team_away_id,
	matches.team_home_id,
	matches.next_match_id,
	(
		CASE
	    WHEN (status = 'upcoming' OR status = 'started') THEN NULL
	    WHEN (
        team_home_et_score IS NULL AND
        team_away_et_score IS NULL AND
        team_home_ps_score IS NULL AND
        team_away_ps_score IS NULL AND
		    team_home_score = team_away_score
	  	) THEN 'draw'
	    WHEN (
		    team_home_score > team_away_score OR
		    (team_home_et_score IS NOT NULL AND team_home_et_score > team_away_et_score) OR
		    (team_home_ps_score IS NOT NULL AND team_home_ps_score > team_away_ps_score)
		) THEN 'home'
		ELSE 'away'
		END
	) AS winning_side,
	r.number AS round_number,
	r.points AS points,
	r.name AS round_name,
	ARRAY(SELECT DISTINCT p.user_id FROM predictions p WHERE p.match_id = matches.id AND p.user_id IN (SELECT user_id FROM leaderboard_users lu WHERE lu.id = l.id) AND p.choice = 'home') as predicted_home,
	ARRAY(SELECT DISTINCT p.user_id FROM predictions p WHERE p.match_id = matches.id AND p.user_id IN (SELECT user_id FROM leaderboard_users lu WHERE lu.id = l.id) AND p.choice = 'draw') as predicted_draw,
	ARRAY(SELECT DISTINCT p.user_id FROM predictions p WHERE p.match_id = matches.id AND p.user_id IN (SELECT user_id FROM leaderboard_users lu WHERE lu.id = l.id) AND p.choice = 'away') as predicted_away
FROM matches
JOIN rounds r ON matches.round_id = r.id
JOIN leaderboards l ON l.competition_id = matches.competition_id
ORDER BY matches.id

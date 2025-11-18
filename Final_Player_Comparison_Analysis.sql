-- ASSIGNMENT: Player Comparison Analysis

-- a) Which players have the same birthday?
-- 	  a1. Finds the unique MM-DD combinations (birthdays) that are shared by more than one player
WITH shared_birthday AS(
			SELECT 		CONCAT(TRIM(birthMonth), '-', TRIM(birthDay)) as shared_birthday_key
			FROM 		players
			WHERE 		birthMonth IS NOT NULL
						AND birthDay IS NOT NULL
			GROUP BY 	shared_birthday_key
			HAVING 		COUNT(playerID) > 1
)
-- 	  a2. Finds the players who share the same birthdays by matching the shared_birthday_key with their birthdays
SELECT 		p.playerID, 
			p.nameFirst, 
			p.nameLast,
			CONCAT(TRIM(p.birthMonth), '-', TRIM(p.birthDay)) as player_birthday
FROM 		players p
INNER JOIN 	shared_birthday sb
ON 			CONCAT(TRIM(p.birthMonth), '-', TRIM(p.birthDay)) = sb.shared_birthday_key
ORDER BY 	player_birthday, nameLast;

-- b) Create a summary table that shows for each team, what percent of players bat right, left and both.
--    b1. Calculates the total number of unique players for each team
WITH TeamPlayers AS(
			SELECT 		teamID, COUNT(DISTINCT playerID) AS num_players
			FROM 		salaries
			GROUP BY 	teamID
),
	 BattingCount AS(
--    b2. Calculates the count of players who bat Right (R), Left (L), or Both (B) for each team
			SELECT 		s.teamID, 
						SUM(CASE WHEN p.bats = 'R' THEN 1 ELSE 0 END) AS right_batters,
						SUM(CASE WHEN p.bats = 'L' THEN 1 ELSE 0 END) AS left_batters,
						SUM(CASE WHEN p.bats = 'B' THEN 1 ELSE 0 END) AS both_batters
			FROM (		
						SELECT DISTINCT	playerID, teamID
						FROM 			salaries 
						) s
			INNER JOIN 	players p
			ON 			s.playerID = p.playerID
			GROUP BY 	s.teamID
)
-- Final Step: Calculates the percentages by dividing the count by the total and formatting the output
SELECT 		tp.teamID,
			ROUND(CAST(bc.right_batters AS REAL) * 100 / tp.num_players, 2) AS percent_right,
			ROUND(CAST(bc.left_batters AS REAL) * 100 / tp.num_players, 2) AS percent_left,
			ROUND(CAST(bc.both_batters AS REAL) * 100 / tp.num_players, 2) AS percent_both,
			tp.num_players
FROM 		TeamPlayers tp
INNER JOIN 	BattingCount bc
ON 			tp.teamID = bc.teamID;

-- c) How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?

-- c1. Calculates the average height and weight of players each year
WITH YearlyAverages AS (
					SELECT 	ROUND(AVG(height), 0) AS avg_height, 
							ROUND(AVG(weight), 0) AS avg_weight, 
							YEAR(debut) AS debut_year
					FROM 	players
					WHERE 	height IS NOT NULL
							AND weight IS NOT NULL
							AND debut IS NOT NULL
					GROUP BY debut_year
)
-- c2. Calculates the changes over the years
SELECT 		debut_year,
			avg_height, 
			avg_height - LAG(avg_height, 1) OVER (ORDER BY debut_year) AS height_diff,
			avg_weight,
			avg_weight - LAG(avg_weight, 1) OVER (ORDER BY debut_year) AS weight_diff
FROM 		YearlyAverages
ORDER BY 	debut_year;

-- c3. Calculates the changes over the decades
WITH DecadeAverages AS (
					SELECT 	ROUND(AVG(height), 0) AS avg_height, 
							ROUND(AVG(weight), 0) AS avg_weight,
 							FLOOR((YEAR(debut) / 10)) * 10 AS debut_decade
					FROM 	players
					WHERE 	height IS NOT NULL
							AND weight IS NOT NULL
							AND debut IS NOT NULL
					GROUP BY debut_decade
)
SELECT 		debut_decade,
			avg_height, 
			avg_height - LAG(avg_height, 1) OVER (ORDER BY debut_decade) AS height_diff,
			avg_weight,
			avg_weight - LAG(avg_weight, 1) OVER (ORDER BY debut_decade) AS weight_diff
FROM 		DecadeAverages
ORDER BY 	debut_decade;
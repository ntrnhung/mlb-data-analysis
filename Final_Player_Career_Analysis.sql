-- ASSIGNMENT: Player Career Analysis

-- a) For each player, calculate their age at their first (debut) game, their last game, and their career length (all in years). 
-- Sort from longest career to shortest career.
WITH 	player_careers AS
-- 		Calculates age at the players' first and last game
(SELECT playerID, 
		TRUNCATE(DATEDIFF(debut, CONCAT(birthYear, '-', birthMonth, '-', birthDay)) / 365.25, 0) AS debut_age,
        TRUNCATE(DATEDIFF(finalGame, CONCAT(birthYear, '-', birthMonth, '-', birthDay)) / 365.25, 0) AS last_game_age
FROM 	players
WHERE 	debut IS NOT NULL 
		AND finalGame IS NOT NULL
		AND birthYear IS NOT NULL
		AND birthMonth IS NOT NULL
		AND birthDay IS NOT NULL)

SELECT  playerID,
		debut_age,
		last_game_age,
-- 		Calculates career length in years
		last_game_age - debut_age AS career_years
FROM	player_careers
ORDER BY career_years DESC;

-- b) What team did each player play on for their starting and ending years?
WITH	first_and_last_years AS 
-- 	  b1. Finds the first and last year a player was paid
			(SELECT playerID,
					MIN(yearID) AS first_year,
					MAX(yearID) AS last_year
			FROM 	salaries
            WHERE 	yearID IS NOT NULL
			GROUP BY playerID),
            
-- 	  b2. Joins to get the teamID for the first year
		first_year_team AS
			(SELECT fnl.playerID,
					fnl.first_year,
                    s.teamID AS starting_team
			FROM 	first_and_last_years fnl
			INNER JOIN salaries s
			ON 		fnl.playerID = s.playerID
					AND fnl.first_year = s.yearID),
            
-- 	  b3. Joins to get the teamID for the last year
		last_year_team AS
			(SELECT fnl.playerID,
					fnl.last_year,
                    s.teamID AS ending_team
			FROM 	first_and_last_years fnl
			INNER JOIN salaries s
			ON 		fnl.playerID = s.playerID
					AND fnl.last_year = s.yearID)
            
-- 	  Final Step: Combines the starting and ending team data
SELECT  first_year_team.playerID, 
		first_year_team.first_year, 
		first_year_team.starting_team,
        last_year_team.last_year,
        last_year_team.ending_team
FROM 	first_year_team
INNER JOIN last_year_team
ON 		first_year_team.playerID = last_year_team.playerID
ORDER BY first_year;

-- c) How many players started and ended on the same team and also played for over a decade?
WITH	first_and_last_years AS 
-- 	  c1. Finds the first and last year a player was paid
			(SELECT playerID,
					MIN(yearID) AS first_year,
					MAX(yearID) AS last_year
			FROM 	salaries
            WHERE 	yearID IS NOT NULL
			GROUP BY playerID),
            
-- 	  c2. Joins to get the teamID for the first year
		first_year_team AS
			(SELECT fnl.playerID,
					fnl.first_year,
                    s.teamID AS starting_team
			FROM 	first_and_last_years fnl
			INNER JOIN salaries s
			ON 		fnl.playerID = s.playerID
					AND fnl.first_year = s.yearID),
            
-- 	  c3. Joins to get the teamID for the last year
		last_year_team AS
			(SELECT fnl.playerID,
					fnl.last_year,
                    s.teamID AS ending_team
			FROM 	first_and_last_years fnl
			INNER JOIN salaries s
			ON 		fnl.playerID = s.playerID
					AND fnl.last_year = s.yearID)
            
-- 	  c4. Combines the starting and ending team data
SELECT  COUNT(first_year_team.playerID) AS players_who_started_and_ended_on_the_same_team_for_over_a_decade
FROM 	first_year_team
INNER JOIN last_year_team
ON 		first_year_team.playerID = last_year_team.playerID
-- 	  c5. Filters to find players who started and ended on the same team 
WHERE	first_year_team.starting_team = last_year_team.ending_team
--    c6. And ones who played for more than a decade
AND 	last_year - first_year >= 10
ORDER BY first_year;
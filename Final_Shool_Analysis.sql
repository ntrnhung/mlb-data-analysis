-- ASSIGNMENT: School Analysis

-- a) In each decade, how many schools were there that produced MLB players?
SELECT  FLOOR(yearID / 10) * 10 AS decade,
		COUNT(DISTINCT schoolID) AS num_schools
FROM 	schools
GROUP BY decade
ORDER BY decade;

-- b) What are the names of the top 5 schools that produced the most players?
SELECT sd.name_full AS school_name,
	   COUNT(DISTINCT playerID) AS num_players_produced
FROM   schools s
INNER JOIN school_details sd
ON 	   s.schoolID = sd.schoolID
GROUP BY sd.name_full
ORDER BY num_players_produced DESC
LIMIT 5;

-- c) For each decade, what were the names of the top 3 schools that produced the most players?
WITH ds AS(SELECT 
-- 	  c1. Calculates the total number of unique players produced by each school, for each decade
				FLOOR(yearID / 10) * 10 AS decade, 
				sd.name_full AS school_name,
				COUNT(DISTINCT playerID) AS num_players_produced
			FROM schools s
			LEFT JOIN school_details sd
			ON s.schoolID = sd.schoolID
			GROUP BY decade, sd.schoolID, school_name),
-- 	  c2. Ranks the schools within each decade based on the number of players produced.  
     rn AS(SELECT decade, school_name, num_players_produced,
			ROW_NUMBER() OVER(
				PARTITION BY decade 
				ORDER BY num_players_produced DESC) AS row_num
			FROM ds)
            
-- 	  Final Step: Filters the ranked data to retrieve only the top 3 schools (row_num <= 3) for each decade
SELECT  decade, school_name, num_players_produced
FROM	rn
WHERE 	row_num <= 3
ORDER BY decade DESC, row_num;

-- ASSIGNMENT: Salary Analysis

-- a) Return the top 20% of teams in terms of average annual spending

WITH total_annual_spending AS 
--    a1. Calculates the total money spent by each team in each year
	(SELECT DISTINCT 
			yearID,
			teamID,
			SUM(salary) OVER(PARTITION BY yearID, teamID) AS annual_spending_amount
	FROM 	salaries),
--    a2. Calculates the average of the annual totals from a1 for each team
    overall_avg_spending AS
	(SELECT  teamID,
			 AVG(annual_spending_amount) AS overall_avg_annual_spending
	FROM 	 total_annual_spending
    GROUP BY teamID),
--    a3. Rank the average spending from a2 for each team 
--    Bucket (1) contains the top 20% spenders
    ranked_teams AS
    (SELECT teamID,
			overall_avg_annual_spending,
            NTILE(5) OVER (ORDER BY overall_avg_annual_spending DESC) AS top_20
	FROM	overall_avg_spending) 

--    Final Step: Filters the ranked teams to only include those assigned to the highest spending bucket (1).
SELECT 	teamID,
		overall_avg_annual_spending
FROM	ranked_teams
WHERE 	top_20 = 1;

-- b) For each team, show the cumulative sum of spending over the years

SELECT  DISTINCT 
		yearID,
		teamID,
		SUM(salary) OVER(PARTITION BY teamID ORDER BY yearID) AS running_total_spending
FROM 	salaries
ORDER BY teamID, yearID;
    
-- c) Return the first year that each team's cumulative spending surpassed 1 billion

WITH cummulative_sum AS
-- 	 a1. Calculates the running total of spending for each team over the years
		(SELECT DISTINCT 
				yearID,
				teamID,
				SUM(salary) OVER(PARTITION BY teamID ORDER BY yearID) AS running_total_spending
		FROM 	salaries),
-- 	 a2. Filters the results to only include rows where the cumulative spending is $1B or more
	 billion_year AS
		(SELECT yearID, 
				teamID,
				running_total_spending
		FROM 	cummulative_sum
		WHERE 	running_total_spending > 1000000000)
        
--   Final Step: For each team, find the MINIMUM (first) yearID from the filtered list (a2)
SELECT  teamID, 
		MIN(yearID) AS first_year_over_1_billion
FROM 	billion_year
GROUP BY teamID
ORDER BY first_year_over_1_billion, teamID;

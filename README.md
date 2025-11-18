# mlb-data-analysis

# ⚾ MLB Data Analysis Project: Advanced SQL Querying

## 🚀 Project Overview

This project demonstrates **advanced SQL querying techniques** applied to a relational database containing Major League Baseball (MLB) player, team, and salary data. Moving beyond basic SELECT statements, this work showcases complex data transformations, statistical analysis, and business-focused reporting using modern analytical SQL functions.

This repository is based on the final project for the **"SQL for Data Analysis: Advanced SQL Querying Techniques"** course on Udemy, extended with additional analysis and refinements.

---

## ✨ Key SQL Skills Demonstrated

This project showcases proficiency in advanced SQL concepts essential for modern Data Analyst roles:

### 1. Window Functions (Analytical Power)
* **Cumulative Aggregations:** Used `SUM() OVER (PARTITION BY ... ORDER BY ...)` to calculate running totals for team spending over time
* **Ranking and Bucketing:** Employed `NTILE(5)` to categorize teams into spending quintiles and `ROW_NUMBER()` with `PARTITION BY` to solve "Top N Per Group" problems (e.g., top 3 schools per decade)
* **Lag/Lead Analysis:** Utilized `LAG()` to compare player attributes year-over-year, revealing longitudinal trends in player demographics

### 2. Complex Query Structure & Logic
* **Common Table Expressions (CTEs):** Broke down multi-step analytical processes into logical, readable, and reusable components for clean, efficient, and auditable code
* **Date and Time Manipulation:** Calculated precise player metrics such as age at debut, age at final game, and total career length using `DATEDIFF()`, `YEAR()`, and `TRUNCATE()`
* **Conditional Aggregation & Joins:** Performed multi-condition joins and used `GROUP BY` with `HAVING` to identify patterns like shared birthdays and career team tenure

### 3. Business Intelligence & Reporting
* Translated complex business questions into actionable SQL queries
* Created analytical frameworks for trend analysis and comparative reporting
* Designed reusable query patterns for recurring analytical needs

---

## 🔎 Analytical Questions & Insights

The SQL queries answer complex analytical questions across four major themes:

| Analysis File | Key Questions Answered | Advanced Techniques |
| :--- | :--- | :--- |
| **Final_Salary_Analysis.sql** | 📈 Which teams are in the top 20% of average annual spending? When did each team's cumulative spending surpass $1 Billion? | NTILE(), SUM() OVER(), First Occurrence Logic |
| **Final_School_Analysis.sql** | 🎓 What are the top 3 player-producing schools in each decade? How has school participation evolved over time? | ROW_NUMBER() OVER(PARTITION BY), FLOOR() for Decade Bucketing |
| **Final_Player_Career_Analysis.sql** | ⏳ How long were players' careers? Which players started and ended with the same team for 10+ years? | DATEDIFF(), TRUNCATE(), Multi-step CTE Logic |
| **Final_Player_Comparison_Analysis.sql** | 🧑‍🤝‍🧑 What percentage of team players bat right/left/both? How have player heights and weights changed over time? | LAG(), Conditional Counting, HAVING Filters |

---

## 📂 Project Structure

```
mlb-data-analysis/
│
├── create_statements_final_project_mysql.sql    # DDL for database schema
├── Final_Salary_Analysis.sql                    # Team spending & payroll trends
├── Final_School_Analysis.sql                    # College player production analysis
├── Final_Player_Career_Analysis.sql             # Career longevity & tenure tracking
├── Final_Player_Comparison_Analysis.sql         # Player demographics & trends
└── README.md                                     # Project documentation
```

---

## 🛠️ Technology Stack

* **Database:** MySQL 8.0+
* **Core Techniques:** Window Functions, CTEs, Date/Time Functions, Multi-step Joins, Subqueries
* **Analysis Focus:** Trend Analysis, Ranking, Comparative Statistics, Time-Series Data

---

## 💻 Getting Started

### Prerequisites
* MySQL 8.0 or higher installed
* MySQL Workbench or any SQL client
* Basic understanding of relational databases

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/mlb-data-analysis.git
   cd mlb-data-analysis
   ```

2. **Set up MySQL database**
   ```sql
   CREATE DATABASE mlb_analytics;
   USE mlb_analytics;
   ```

3. **Create tables and load schema**
   ```bash
   mysql -u your_username -p mlb_analytics < create_statements_final_project_mysql.sql
   ```

4. **Load historical MLB data**
   * The project uses publicly available MLB historical data
   * Data sources: [Sean Lahman's Baseball Database](http://www.seanlahman.com/baseball-archive/statistics/)
   * Import CSV files into the created tables using MySQL's LOAD DATA INFILE or your SQL client's import functionality

5. **Run analysis queries**
   * Open any Final_*.sql file in your SQL client
   * Execute queries individually or as a complete script
   * Review results and modify parameters as needed

---

## 📊 Sample Query

Here's an example query that identifies teams in the top 20% of spending using NTILE():

```sql
WITH team_avg_salaries AS (
    SELECT 
        team_id,
        AVG(salary) AS avg_annual_salary
    FROM salaries
    GROUP BY team_id
),
team_quintiles AS (
    SELECT 
        team_id,
        avg_annual_salary,
        NTILE(5) OVER (ORDER BY avg_annual_salary DESC) AS spending_quintile
    FROM team_avg_salaries
)
SELECT 
    team_id,
    ROUND(avg_annual_salary, 2) AS avg_salary,
    spending_quintile
FROM team_quintiles
WHERE spending_quintile = 1
ORDER BY avg_annual_salary DESC;
```

---

## 🎯 Key Insights Discovered

* **Spending Patterns:** Top-tier teams consistently maintain payrolls 3-4x higher than bottom quintile teams
* **School Trends:** Traditional baseball powerhouses dominate player production, but participation has diversified over decades
* **Career Longevity:** Players who debut younger tend to have longer careers, with sweet spot at 21-23 years old
* **Player Evolution:** Average player height and weight have increased significantly since the 1970s

---

## 📧 Contact

**Nhung Nguyen**
* GitHub: [@ntrnhung](https://github.com/ntrnhung)
* LinkedIn: [Nhung Nguyen](https://www.linkedin.com/in/trangnhungnguyen)
* Email: ntrnhung@outlook.com


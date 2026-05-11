# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

SQL queries? Check them out here [project_sql folder](/Project_sql/)
# Background
This project was created to help navigate the data analyst job market more effectively. Its goal is to idenitfy the highest paid and most in-demand skills, making it easier to find the best job opportunites.

## The questions i wanted to answer through my sql queries:
1. What are the top paying data analyst jobs?
2. What skills are required for those top-paying jobs?
3. What skills are most in-demand for data analyst?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I Used
For this deep analysis into the data analyst job market, I relied in on a few core tools:
- **SQL :** Used it to query the database and pull out key insights that drove my analysis.
- **PostgreSQL :** Chosen as the database system for managing the job posting data
- **Virtual Studio Code :** My main main environment for writing and running SQL queries
- **Git & Github :** Used for version control and sharing my scripts which made collaboratioon and tracking changes easier.
# The Analysis
Each query for this project was used to analyze specific aspects of the data analyst job market. Here's how i approached each question:
### 1. Top Paying Data Analyst Jobs
To pinpoint the best-paying data analyst roles, i filtered the data by average yearly salary and location, focusing on remote positions. This query surfaces the top-paying jobs in the field.


```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10;
```
Here's the breakdown of the top data analyst jobs in 2023:
- Senior roles like Director of Analytics and Principal Data Analyst earn the highest salaries, showing experience increases pay.
- **Large Salary Range:** The top-paying data analyst positions range between **$184K and $650K**, highlighting the strong earning potential in the industry.

* **Variety of Employers:** Major companies such as SmartAsset, Meta, and AT&T offer these high-paying roles, reflecting demand across multiple sectors.

![Top paying data analyst jobs](Assets\top_paying_data_analyst_jobs.png)
Bar graph visualizing the salary for the top 10 salaries for data analysts

### 2. Skills for Top Paying Jobs
To know the required skills for top payiing jobs, i joined the job postings with the skills data, giving a clearer understanding of the skills and qualities employers prioritize for high-paying positions.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC;
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** and **Python** are the most common skills across nearly all top-paying data analyst roles, making them essential for high-salary opportunities.
- Tableau is also highly sought after. Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

![Top skills for high paying roles](Assets\Code_Generated_Image.png)

### 3. In-Demand Skills for Data Analysts
This query focused on identifying skills that are frequently requested for data analyst roles.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
Here is a quick breakdown of what the data tells us:
* **Database Dominance:** SQL remains the primary requirement for data roles, significantly outpacing other technical competencies and spreadsheets.
* **Visualization & Scripting:** There is high demand for a mix of programming and dashboarding tools, showing a clear need for both data processing and visual storytelling.

| Skill | Demand Count |
| :--- | :--- |
| SQL | 7,291 |
| Excel | 4,611 |
| Python | 4,330 |
| Tableau | 3,745 |
| Power BI | 2,609 |

Table of the demand for the top 5 skills in data analyst job postings
### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Based on the salary data for Data Analysts, here is a breakdown of the highest-paying skills.

- **Big Data & Specialized Processing:** PySpark leads the list with an average salary of demonstrating that the ability to handle large-scale data processing is the most lucrative skill for analysts today.

- **Engineering & Collaboration Tools:** High salaries for Bitbucket and GitLab suggest that high-paying roles require analysts to follow software engineering best practices, including version control and collaborative development.

- **AI & Data Science Ecosystem:** The inclusion of Watson, DataRobot, and Pandas indicates that top earners are effectively integrating automated machine learning and advanced Python libraries into their analytical workflows.

| Skill | Average Salary (USD) |
| :--- | :--- |
| pyspark | $208,172 |
| bitbucket | $189,155 |
| couchbase | $160,515 |
| watson | $160,515 |
| datarobot | $155,486 |
| gitlab | $154,500 |
| swift | $153,750 |
| jupyter | $152,777 |
| pandas | $151,821 |
| elasticsearch | $145,000 |
Table of the average salary for the top 10 paying skills for data analysts

### 5. Most Optimal Skills to Learn
By merging demand and salary metrics, this analysis identifies the "sweet spot" of high-value skills—those that are both widely sought after and highly compensated—to provide a clear roadmap for strategic career growth.

```sql
WITH skills_demand AS ( 
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) avg_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE 
    demand_count > 10
ORDER BY
   avg_salary DESC, 
   demand_count DESC
LIMIT 25;
```
Breakdown of Optimal Skills

- **Cloud & Big Data Command Premiums:** Cloud platforms like Azure, AWS, and Snowflake consistently command salaries over $108,000. Their specialized nature makes them highly lucrative for analysts.

- **Programming Versatility:** While Python remains the high-demand powerhouse (236 mentions), niche languages like Go and Java actually offer higher average salaries, suggesting that polyglot analysts who can handle backend or system-level tasks are significantly rewarded.

- **Workflow & Infrastructure Proficiency:** Tools like Confluence, Jira, and Hadoop appear in the top salary bracket. This highlights that "optimal" career growth isn't just about data analysis itself, but also about mastering the collaborative frameworks and infrastructure used to manage large-scale data projects.

| Skill | Demand Count | Average Salary ($) |
| :--- | :--- | :--- |
| go | 27 | $115,320 |
| confluence | 11 | $114,210 |
| hadoop | 22 | $113,193 |
| snowflake | 37 | $112,948 |
| azure | 34 | $111,225 |
| bigquery | 13 | $109,654 |
| aws | 32 | $108,317 |
| java | 17 | $106,906 |
| ssis | 12 | $106,683 |
| jira | 20 | $104,918 |

Table of the most optimal skills for data analyst sorted by salary

# What I Learned
Over the course of this project, I’ve transformed my technical capabilities by mastering several high-impact SQL techniques:

- **Advanced Query Engineering:** I’ve moved beyond the basics to craft complex queries, utilizing professional grade table joins and Common Table Expressions (CTEs) to streamline data processing.

- **Precision Aggregation:** I’ve harnessed the power of GROUP BY and aggregate functions like COUNT() and AVG() to distill massive datasets into meaningful summaries.

- **Strategic Problem Solving:** I’ve learned to bridge the gap between business questions and technical execution, translating real-world requirements into efficient, actionable code.
# Conclusions

### Key Market Insights
My data analysis revealed several critical trends within the current Data Analyst landscape:

- **The Salary Ceiling:** Remote friendly data roles offer a vast compensation range, with elite positions reaching as high as $650,000.

- **The SQL Essential:** There is a direct correlation between high-paying roles and SQL proficiency; it remains both the most demanded skill and a primary gatekeeper for top-tier salaries.

- **Niche Premiums:** While foundational tools are essential, specialized expertise in niche areas like Solidity or SVN commands a significant salary premium.

- **The Optimal Skillset:** To maximize market value, SQL is the clear winner offering the perfect intersection of high frequency in job postings and competitive average pay.

### Final Reflection

This exploration has done more than just sharpen my technical toolkit; it has provided a strategic roadmap for the data industry. By identifying the skills that offer the best return on investment, Professional development can now be priortized with data-driven confidence. In an ever-evolving market, this project reinforces that the most successful analysts are those who combine deep technical mastery with a keen understanding of emerging industry trends.
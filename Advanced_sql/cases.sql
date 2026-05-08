SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE   
    job_title_short = 'Data Analyst'
GROUP BY 
    location_category;


-- problem 7
WITH remote_job_skills AS (
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = TRUE AND
    job_postings.job_title_short = 'Data Analyst'
GROUP BY
    skill_id
)
SELECT 
    skill.skill_id,
    skills AS skill_name,
    remote_job_skills.skill_count
FROM
    remote_job_skills
INNER JOIN skills_dim AS skill ON skill.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT
    5;


SELECT
    skills_job_dim.skill_id,
    skills AS skill_name
FROM
    skills_job_dim
INNER JOIN skills_dim AS skill ON skill.skill_id = skills_job_dim.skill_id
WHERE skill_job_dim.skill_id IN (
   
)
LIMIT
    5;


-- Subquery practice problem 
SELECT 
    skill_number.skill_id,
    skill_count,
    skills AS skill_name
FROM  (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim
    GROUP BY skill_id
    ORDER BY skill_count DESC
    LIMIT 5    
) AS skill_number 
INNER JOIN skills_dim AS SD ON SD.skill_id = skill_number.skill_id
ORDER BY skill_count DESC


-- CTEs practice problem

WITH company_result AS (
    SELECT
        company_id,
        job_count,
        CASE
            WHEN job_count < 10 THEN 'Small'
            WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
            WHEN job_count > 50 THEN 'Large'
            ELSE 'Low'
        END AS size_category
    FROM (
        SELECT 
            company_id,
            COUNT (*) AS job_count
        FROM
            job_postings_fact
        GROUP BY
            company_id
        ) AS company_count
)
SELECT
    company_dim.name AS company_name,
    company_result.job_count,
    size_category
FROM company_result
LEFT JOIN company_dim ON company_result.company_id = company_dim.company_id


-- practice problem 8

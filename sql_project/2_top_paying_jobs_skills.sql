/*What skills are required for the top paying data science jobs?*/

WITH top_paying_jobs AS 
(
    SELECT
        job_id, 
        job_title,
        name AS company_name,
        job_location,
        ROUND(salary_year_avg,0) AS salary_year_avg
    FROM 
        job_postings_fact
    LEFT JOIN 
        company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE 
        job_title_short = 'Data Scientist'
        AND job_location IS NOT NULL
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10    
)

SELECT
    job_title,
    skills,
    salary_year_avg,
    company_name
FROM 
    top_paying_jobs
INNER JOIN 
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC




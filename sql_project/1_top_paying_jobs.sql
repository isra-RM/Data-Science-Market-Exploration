/*What are the top paying data science jobs?*/

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

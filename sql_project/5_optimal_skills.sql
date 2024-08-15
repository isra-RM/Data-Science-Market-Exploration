/*What are the optimal skills to learn (both high-demand and high-paying)?
To combine the demand for a job and the pay for that job into a single quantity, you can use the concept of total earnings. Total earnings are calculated by multiplying the number of job positions (demand) by the pay for each position.*/


SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_dim.skills) AS demand,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary,
    ROUND(COUNT(skills_dim.skills) * AVG(job_postings_fact.salary_year_avg),0) AS total_earnings
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
ORDER BY
    total_earnings DESC
LIMIT 10









# Introduction
This is a simple analysis of the data job market 📊 from the Luke Barousse SQL course. Focusing on data science jobs, this project explores top-paying jobs 💸, in-demand skills 📈 and where high salary meets high demand 🔥.

🔎 Check SQL queries here: [project_sql_folder](/sql_project/)

### Questions
I wanted to answer the following questions about data market:
1. What are the top paying data science jobs?
2. What skills are required for the top paying data science jobs?
3. What are the most in demand skills for data science jobs?
4. Which skills are associated with higher salaries?
5. What are the optimal skills to learn (both high paying and high demand)?

# Tools

For this analysis I used the following tools:

-**SQL**.\
-**PostgreSQL**.\
-**Visual Studio Code**.\
-**Git & GitHub**.

# Analysis
Each SQL query of this project is aimed at uncovering different aspects and trends in the data job market.

### 1. What are the top paying data science jobs?
To find the highest-paying jobs, I filtered for data scientist, location (remote jobs), and average yearly salary.

```sql
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
```
![Top-paying jobs](/assets/query1.png)

The key insights from this visualization:

1. The highest-paying data science job by a wide margin is the "Data Scientist" from East River Electric Power Cooperative with an average salary of $960,000.
2. The second highest-paying job is the "GIS Analyst" with an average salary of $585,000.
3. There are several director-level data science roles which command salaries in the range of $300,000 to $400,000.

### 2. What skills are required for the top-paying data science jobs?
To find what skills are required for this top-paying jobs, I joined the job postings data with the skill data. This allow me to discover what specific skills high-paying roles demand.

```sql
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
```
Here are the most demanded skills fot the top paying data science jobs in 2023:

![Most demanded skills for top paying jobs](/assets/query2.png)

From this visualization we can clearly see that **Python** and **SQL** are the leading skills for high-paying data science jobs. In the second place we have **R** another programming language which is highly sought after. It is worth noting that knowing a programming language (**Python**, **SQL**, **C++**, and **Java**,) will definitely give you a competitive edge.

### What are the most in demand skills for data science jobs?

This query identifies the most frequently requested skills in job postings.

```sql
SELECT
    skills,
    COUNT(skills) AS demand
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
GROUP BY
    skills
ORDER BY
    demand DESC
LIMIT 5
```
When we take into account all jobs, not just top-paying jobs, Python and SQL are the most in demand skills.

| Skill | Demand Count |
|-------|--------------|
| Python | 114016 |
| SQL | 79174 |
| R | 59764 |
| SAS | 29642 |
| Tableau | 29513 |

### Which skills are associated with higher salaries?
To reveal which skills are the highest paying, I explore the average salaries associated with different skills.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS average_salary
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
    skills
ORDER BY
    average_salary DESC
LIMIT 10
```
![Skills asociated with the highest average salary](/assets/query4.png)

### What are the top earnings skills to learn (both high paying and high demand)?

We analyzed which are the skills associated with the highest average salaries in the last question, however these skills are not very demanded. In order to find the optimal skills to learn (high compensation and high demand) we turn to the total earning of a skill, defined as:

$$total \: earnings = salary \times demand$$

```sql
SELECT
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
```
![Top optimal skills](/assets/query5.png)

Once again we have **Python** as the clear winner followed by **SQL** and **R**. We see some cloud computing skills like **AWS** and **Azure** , big data skills like **Spark** and **Hadoop** and deep learning frameworks like **Pytorch** and **Tensorflow**.

# Conclusions

1. **Top-paying data science jobs**: The highest paying jobs for data scientist offers a wide range of salaries from $300 000 to $900 000.
2. **Skills for top-paying jobs**: High paying data science jobs required knowledge of Python and SQL.
3. **Most in-demand skills**: Python is the most demanded skill in the data science world.
4. **Skills with higher salaries**: Project management and collaborative softwares like Asana and Airtable are associated with the highest salaries, indicating the importance of collaboration and team work.
5. **Optimal skills**: Python is again the optimal skill to learn for data scientist looking to maximize their maket value.

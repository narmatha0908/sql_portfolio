/*
question : what skills are required for the top-paying data analyst jobs?
-use the top 10 highest-paying data analyst jobs from first query
-add the specific skills required for these roles
-why?it provides a detailed look at which high-paying jobs demand certain skills,
 helping job seekers understand which skills to develop that align with top salaries
 */

WITH top_paying_jobs AS(
    SELECT 
        jpf.job_id,
        jpf.job_title,
        cd.name AS company_name,
        jpf.salary_year_avg

    FROM
        job_postings_fact AS jpf
    LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
    WHERE
        job_title_short = 'Data Analyst' AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
    tpj.*,
    sd.skills
FROM top_paying_jobs AS tpj
INNER JOIN skills_job_dim AS sjd
ON tpj.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sd.skill_id = sjd.skill_id
ORDER BY
salary_year_avg DESC


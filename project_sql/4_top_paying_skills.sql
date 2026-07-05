/*
question : what are the top skills based on salary?
-look at the avg salary for each skill for data analyst 
-focus on roles with salary regardless of location
- why? it reveals how diff skills impact salary levels for data analyst and
 helps identify the most financially rewarding skills for job seekers
 */

 SELECT
    sd.skills,
    ROUND(AVG(jpf.salary_year_avg),0)AS avg_salary
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sd.skill_id = sjd.skill_id
WHERE 
    jpf.job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    --AND jpf.job_work_from_home = TRUE
GROUP BY
     sd.skills
ORDER BY
     AVG(jpf.salary_year_avg) DESC 
LIMIT 25
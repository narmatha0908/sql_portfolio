/*
question : what are the most in-demand skills for data analyst?
- join job postings to inner join table similar to query 2
- identify the top 5 demand skills for data analyst
- focus on all job postings
- why? retrives top 5 skills with highest demand in the market and 
give meaningful insights to job seekers
*/

SELECT
    sd.skills,
    COUNT(sd.skills)
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sd.skill_id = sjd.skill_id
WHERE 
    jpf.job_title_short = 'Data Analyst' AND jpf.job_work_from_home = TRUE
GROUP BY
     sd.skills
ORDER BY
     COUNT(sd.skills) DESC
LIMIT 5
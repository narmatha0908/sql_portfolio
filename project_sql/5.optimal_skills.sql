/*
question : what are the most optimal skills to learn (aka it's in high demand and high paying skills)
- identify skills in high demand and associated with high average salariesfor data analyst roles
- focus on remote positons with salaries
- why? targets skills that offer  job security (high demand) and financial benefits (high salaries),
 offering strategic guidance for job seekers looking to maximize their career prospects and earning potential
*/
WITH optimal_skills AS(
    SELECT
        sd.skill_id,
        sd.skills,
        COUNT(sd.skills)
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
    WHERE 
        jpf.job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND jpf.job_work_from_home = TRUE
    GROUP BY
        sd.skill_id
),average_salaries AS(
    SELECT
        sd.skill_id,
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
        AND jpf.job_work_from_home = TRUE
    GROUP BY
        sd.skill_id
)
SELECT 
    optimal_skills.skill_id,
    optimal_skills.skills,
    optimal_skills.count,
    average_salaries.avg_salary
FROM
    optimal_skills
INNER JOIN average_salaries
ON optimal_skills.skill_id = average_salaries.skill_id
WHERE
    optimal_skills.count > 10
ORDER BY
    average_salaries.avg_salary DESC,
    optimal_skills.count DESC


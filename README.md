# INTRODUCTION
 This project explores the data analyst job market using SQL and PostgreSQL.

 By analyzing a real-world dataset of job postings, the project identifies high-paying opportunities, the most in-demand skills, and the relationship between salary and technical skills. 

 The goal is to gain practical SQL experience while extracting meaningful insights from job market data.

🔍 sql queries? check them out here : [project_sql folder](/project_sql/)

# BACKGROUND
As I continue preparing for a career in data analytics, I wanted to understand which skills employers value the most and how those skills relate to salary opportunities.

This project uses a real-world dataset of Data Analyst job postings from **2023** to answer practical business questions using SQL.

Although the dataset is historical, it provides valuable insights into salary trends, in-demand skills, and employer requirements within the data analytics job market.

Through this analysis, I explored trends in salaries, identified the most in-demand technical skills, and examined which skills are associated with higher-paying roles.

 The project also served as an opportunity to strengthen my SQL and PostgreSQL skills by solving business-oriented problems.
 ### 🔎 Questions Explored

1. Which data analyst jobs offer the highest salaries?
2. What skills are required for these top-paying positions?
3. Which skills are currently the most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most valuable skills to learn based on demand and salary?

# TOOLS I USED

This project was completed using the following technologies:

- **SQL** – Used to query and analyze the dataset, extracting insights from job market data.
- **PostgreSQL** – Used to create and manage the database where the dataset was stored.
- **Visual Studio Code** – Used for writing, testing, and organizing SQL queries.
- **Git & GitHub** – Used for version control and to maintain the project repository.

# PROJECT ANALYSIS
### 1. Top Paying Data Analyst Jobs

To identify the highest-paying remote Data Analyst opportunities, I filtered the dataset to include only Data Analyst roles with a specified average yearly salary.

 I then joined the company information to display the employer for each job posting and sorted the results by salary in descending order.
 
  Finally, I limited the output to the top 10 highest-paying remote positions.
```sql
SELECT 
    jpf.job_id,
    jpf.job_title,
    cd.name AS company_name,
    jpf.job_location,
    jpf.job_schedule_type,
    jpf.salary_year_avg,
    jpf.job_posted_date
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
```
### Key Insights

- **High Salary Opportunities:** The top 10 remote Data Analyst positions offer significantly high average annual salaries, demonstrating the strong earning potential available for experienced professionals.

- **Multiple Leading Companies:** The highest-paying positions are offered by a variety of companies across different industries, showing that demand for data analysts extends beyond traditional technology companies.

- **Variety of Job Roles:** Although the analysis focuses on Data Analyst positions, the job titles include different levels and specializations, reflecting the diverse career opportunities within the data analytics field.

  ![Top Paying Roles](project_sql\assets\top_paying_jobs.png)

  *Bar chart showing the top 10 highest-paying remote Data Analyst jobs based on the SQL query results. The visualization was generated from the query output.*

### 2. Skills Required for Top-Paying Data Analyst Jobs

After identifying the highest-paying remote Data Analyst positions, I wanted to determine the technical skills required for these roles.

To achieve this, I reused the previous query as a Common Table Expression (CTE) and joined it with the skills tables to retrieve the skills associated with each job posting.

This analysis provides insight into the technologies and tools that employers expect candidates to have for high-paying Data Analyst positions.

``` sql
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
```
### Key Insights

- The highest-paying Data Analyst roles typically require multiple technical skills rather than a single technology.
- SQL appears frequently among the required skills, highlighting its importance for data analyst positions.
- Programming languages, visualization tools, databases, and cloud technologies are commonly listed together, indicating that employers value a well-rounded technical skill set.

### 3. Most In-Demand Skills for Data Analysts

To identify the technical skills that employers request most frequently, I analyzed remote Data Analyst job postings and counted how often each skill appeared.

By grouping the data based on individual skills, this query highlights the technologies that are most valued in the current job market.

``` sql 
SELECT
    sd.skills,
    COUNT(sjd.job_id) AS demand_count
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
     demand_count DESC
LIMIT 5
```
### Key Insights

- **SQL** is the most frequently requested skill, appearing in **7,291** remote Data Analyst job postings, making it one of the core skills for the role.
- **Excel** continues to be highly valued, demonstrating that spreadsheet analysis remains an essential part of data analyst work.
- **Python**, **Tableau**, and **Power BI** are also among the top five skills, indicating that employers expect analysts to combine programming, data visualization, and reporting capabilities.
- The results suggest that developing a strong foundation in SQL and Excel, while learning visualization tools and programming languages, provides a well-rounded skill set for aspiring Data Analysts.

    | Skill | Demand Count |
    |--------|-------------:|
    | SQL | 7,291 |
    | Excel | 4,611 |
    | Python | 4,330 |
    | Tableau | 3,745 |
    | Power BI | 2,609 |

### 4. Highest Paying Skills for Data Analysts

To determine which technical skills are associated with higher salaries, I calculated the average annual salary for each skill across Data Analyst job postings with available salary information. 

The results were then sorted in descending order to identify the skills linked to the highest average salaries.
``` sql
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
```
### Key Insights

- Specialized technologies such as **SVN**, **Solidity**, and **Couchbase** are associated with the highest average salaries in the dataset.
- Many of the highest-paying skills are related to **software development, machine learning, cloud infrastructure, and DevOps**, suggesting that Data Analysts with cross-functional technical expertise can command higher salaries.
- Traditional analytics tools such as SQL and Excel do not appear among the highest-paying skills, indicating that niche or specialized technologies are often rewarded with higher compensation.
- These results highlight that expanding beyond core data analysis skills into advanced technical domains may increase earning potential.

    | Skill | Average Salary ($) |
    |--------|-------------------:|
    | SVN | 400,000 |
    | Solidity | 179,000 |
    | Couchbase | 160,515 |
    | DataRobot | 155,486 |
    | Golang | 155,000 |
    | MXNet | 149,000 |
    | dplyr | 147,633 |
    | VMware | 147,500 |
    | Terraform | 146,734 |
    | Twilio | 138,500 |

> **Note:** Although the SQL query returns the top 25 skills ranked by average salary, only the top 10 are shown here for better readability.

> **Observation:** Some of the highest-paying skills are niche or specialized technologies. Salary alone should not be used to determine which skills to learn; demand and industry relevance should also be considered.

### 5. Most Valuable Skills to Learn

To identify the most valuable skills for aspiring Data Analysts, I combined two key metrics:

how frequently a skill appears in remote Data Analyst job postings and its average annual salary.

By merging demand and salary data, this analysis highlights skills that offer both strong market demand and competitive compensation.
``` sql
WITH optimal_skills AS(
    SELECT
        sd.skill_id,
        sd.skills,
        COUNT(sjd.job_id) AS demand_count
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
    optimal_skills.demand_count,
    average_salaries.avg_salary
FROM
    optimal_skills
INNER JOIN average_salaries
ON optimal_skills.skill_id = average_salaries.skill_id
WHERE
    optimal_skills.demand_count > 10
ORDER BY
    average_salaries.avg_salary DESC,
    optimal_skills.demand_count DESC
```
### Key Insights

- **Python** and **Tableau** stand out as highly valuable skills because they combine strong demand with competitive average salaries, making them excellent choices for aspiring Data Analysts.

- Cloud and big data technologies such as **Snowflake**, **Azure**, **AWS**, and **BigQuery** offer some of the highest average salaries, reflecting the increasing importance of cloud-based data platforms.

- Programming languages including **Go** and **Java** appear among the higher-paying skills, showing that technical expertise beyond traditional analytics can increase earning potential.

- The analysis suggests that developing a combination of SQL, programming, visualization, and cloud technology skills provides a strong foundation for long-term career growth in data analytics.

    | Skill | Demand Count | Average Salary ($) |
    |--------|-------------:|-------------------:|
    | Go | 27 | 115,320 |
    | Confluence | 11 | 114,210 |
    | Hadoop | 22 | 113,193 |
    | Snowflake | 37 | 112,948 |
    | Azure | 34 | 111,225 |
    | BigQuery | 13 | 109,654 |
    | AWS | 32 | 108,317 |
    | Java | 17 | 106,906 |
    | SSIS | 12 | 106,683 |
    | Jira | 20 | 104,918 |


# WHAT I LEARNED

Working on this project gave me practical experience in using SQL to answer real business questions instead of simply writing individual queries. Throughout the project, I strengthened my understanding of concepts such as joins, Common Table Expressions (CTEs), aggregate functions, grouping, filtering, and data analysis techniques.

One of the biggest lessons I learned was that writing a query is only one part of the process. It is equally important to understand the business question, analyze the results, and identify meaningful insights from the data. I also realized that data analysis often involves questioning the data itself, such as identifying unusual values or recognizing patterns that require further investigation.

As this was my first SQL project, it gave me confidence in working with relational databases and showed me how SQL can be used to transform raw data into useful information for decision-making. Overall, this project strengthened both my technical skills and my analytical thinking.

# CONCLUSION

This project allowed me to apply SQL to a real-world dataset and explore different aspects of the Data Analyst job market. By analyzing salaries, job demand, and required skills, I gained a better understanding of the technical skills employers look for and how those skills relate to compensation.

Beyond learning SQL syntax, this project helped me develop a structured approach to solving data problems—starting with a business question, writing SQL queries to answer it, and interpreting the results to draw meaningful conclusions.

As my first SQL portfolio project, it represents an important milestone in my journey toward becoming a Data Analyst. It has also motivated me to continue building my skills through more projects and learning tools such as Power BI, Python, and advanced SQL concepts.


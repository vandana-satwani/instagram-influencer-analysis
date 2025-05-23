/*
---------------------------------------------------------------
    Project: Instagram Influencer Data Analysis
    Internship: CodeBasics Virtual Internship (May 2025)
    Role: Data Analytics Intern – Vandana Satwani

    Description:
    This SQL script explores engagement, content performance,
    and growth metrics of a Tech Instagram Influencer using 
    data from multiple relational tables. Each section includes
    a specific question, SQL query, and business insight.

    Objective:
    To extract meaningful insights that help understand audience 
    behavior, content effectiveness, and optimal posting strategies.

    Note:
    Queries are presented in a question-wise format, as per
    internship guidelines. Insights are provided after each query.
---------------------------------------------------------------
*/
-- Q1: How many unique post types are found in the 'fact_content' table?
SELECT 
        COUNT(DISTINCT post_type) AS unique_post_type_count
FROM fact_content;

-- 📌 Insight: The account uses multiple content formats (e.g., Reels, Images, Videos), showing a diversified content strategy to engage different audience types

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q2: What are the highest and lowest recorded impressions for each post type?
SELECT 
    post_type,
    MAX(impressions) AS highest_impressions,
    MIN(impressions) AS lowest_impressions
FROM fact_content
GROUP BY post_type;

-- 📌 Insight: Some post types consistently generate more impressions than others. This can guide which formats to prioritize in future campaigns.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q3: Filter all posts published on weekends in March and April, export manually from result grid
SELECT fc.*
FROM fact_content fc
JOIN dim_dates dd
  ON fc.date = dd.date
WHERE dd.weekday_or_weekend = 'Weekend'
  AND dd.month_name IN ('March', 'April');
  
  -- 📌 Insight: Filtering weekend posts helps evaluate weekend audience engagement. If weekend posts perform better, the brand can plan major content releases then.
  
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q4: Create a report to get the statistics for the account. The final output includes the following fields: 
SELECT 
    dd.month_name,
    SUM(fa.profile_visits) AS total_profile_visits,
    SUM(fa.new_followers) AS total_new_followers
FROM fact_account fa
JOIN dim_dates dd ON fa.date = dd.date
GROUP BY dd.month_name
ORDER BY dd.month_name;

-- 📌 Insight: Identifies which months had strong performance in terms of attracting followers. Can be used to replicate successful campaigns from those months.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q5: Write a CTE that calculates the total number of 'likes’ for each 
WITH likes_by_category AS (
    SELECT 
        post_category,
        SUM(likes) AS total_likes
    FROM fact_content fc
    JOIN dim_dates dd ON fc.date = dd.date
    WHERE dd.month_name = 'July'
    GROUP BY post_category
)
SELECT *
FROM likes_by_category
ORDER BY total_likes DESC;

-- 📌 Insight: Shows which content category got the most likes in July—useful for targeting audience interests.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q6:  Create a report that displays the unique post_category names alongside their respective counts for each month. The output should have three columns:  
SELECT 
    dd.month_name,
    GROUP_CONCAT(DISTINCT post_category ORDER BY post_category) 
    AS post_category_names,
    COUNT(DISTINCT post_category) AS post_category_count
FROM fact_content fc
JOIN dim_dates dd ON fc.date = dd.date
GROUP BY dd.month_name
ORDER BY dd.month_name;

-- 📌 Insight: Tracks content diversity. Months with more post categories might indicate creative experimentation or campaign variety.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q7:What is the percentage breakdown of total reach by post type?  The final output includes the following fields: 
SELECT 
    post_type,
    SUM(reach) AS total_reach,
    ROUND(SUM(reach) * 100.0 / (SELECT SUM(reach) FROM fact_content), 2) 
    AS reach_percentage
FROM fact_content
GROUP BY post_type
ORDER BY reach_percentage DESC;

-- 📌 Insight: Determines which post types contribute most to overall reach. Use this data to focus on formats with the highest audience penetration.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q8: Create a report that includes the quarter, total comments, and total saves recorded for each post category. Assign the following quarter groupings: 
SELECT 
    post_category,
    CASE 
        WHEN dd.month_name IN ('January', 'February', 'March') THEN 'Q1'
        WHEN dd.month_name IN ('April', 'May', 'June') THEN 'Q2'
        WHEN dd.month_name IN ('July', 'August', 'September') THEN 'Q3'
        ELSE 'Q4'
    END AS quarter,
    SUM(comments) AS total_comments,
    SUM(saves) AS total_saves
FROM fact_content fc
JOIN dim_dates dd ON fc.date = dd.date
GROUP BY post_category, quarter
ORDER BY post_category, quarter;

-- 📌 Insight:Shows how each post category performed in terms of comments and saves across quarters—helpful for spotting seasonal trends in audience engagement.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q9:List the top three dates in each month with the highest number of new followers. The final output should include the following columns: 
SELECT *
FROM (
    SELECT 
        dd.month_name,
        dd.date,
        fa.new_followers,
        RANK() OVER (PARTITION BY dd.month_name ORDER BY fa.new_followers DESC) AS rank_in_month
    FROM fact_account fa
    JOIN dim_dates dd ON fa.date = dd.date
) AS ranked
WHERE rank_in_month <= 3;

-- 📌 Insight:Highlights the top 3 days each month for new followers—ideal for identifying the best days to post or run campaigns.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q10:  Create a stored procedure that takes the 'Week_no' as input and generates a report displaying the total shares for each 'Post_type'. The output of the procedure should consist of two columns: 
 SELECT 
    fc.post_type,
    SUM(fc.shares) AS total_shares
FROM fact_content fc
JOIN dim_dates dd ON fc.date = dd.date 
WHERE dd.week_no = 'W3'
GROUP BY fc.post_type;

-- 📌 Insight:The stored procedure GetSharesByPostType was created to dynamically return total shares for each post type based on the selected week_no. This allows for flexible weekly analysis.For example, running the procedure for W3 returns relevant data instantly, making it efficient for weekly trend comparisons and reporting.


# Website Funnel Analysis - Conversion Rate Optimisation (CRO)

This dataset, available at [Kaggle](https://www.kaggle.com/datasets/aerodinamicc/ecommerce-website-funnel-analysis), contains user behaviour data from an e-commerce website with four pages: home, search, payment, and payment confirmation, tracking user interactions and conversion funnel progression.

There are five tables: a table for each page with the user ID and a flag indicating the user visited the page. The fifth table contains additional user information, including the device type used for accessing the website, the date of activity, and gender.

I analysed the dataset using DBeaver, connected to a PostgreSQL database system. A Power BI report can be found [here](https://github.com/umasreeakula/website_funnel_analysis/blob/main/Website%20Conversion%20Funnel%20Analysis.pbix).

## Business Problem and Scenario

The e-commerce company aims to increase revenue by optimising the conversion rate across its website's funnel. By identifying and addressing the bottlenecks to conversion, the company seeks to enhance the user experience and drive higher sales volume, particularly among new users.

### Questions:
1. What are the conversion rates for each funnel stage, and how do they vary across the different stages? (Home > Search, Search > Payment, Payment > Payment Confirmation)
2. Are there any significant drops or spikes in conversion rates at particular funnel stages?
3. How do conversion rates differ based on user attributes such as device type (desktop, mobile) and sex (male, female)?
4. How do conversion rates vary (daily, weekly, monthly)?

### Insights:
-> Over four months (January–April), 90,400 users landed on the website's home page.
- There were roughly an equal number of female and male users
- Slightly more users accessed the website via desktop than mobile devices. 
- On average, about 22,600 users signed up each month.

-> When examining how many users progressed through each step of the website's journey,
- Roughly half of them showed interest by searching after landing on the website.
- Nearly 13% only proceeded to add a product and head to payment.
- The conversion rate from the payment page to the confirmation of payment page was approximately 7.50%.

-> There was a noticeable decrease in user sessions progressing from the home page to the search page, particularly in March and April.
- This reduced the conversion rate from around 60% in January and February to about 40% in March and April. 
- Similarly, the conversion rate from the search page to the payment page declined from approximately 18% in January and February to around 7% in March.

-> Notably, a significant drop in daily conversion rates started on March 1st.
- The conversion rate from home to search pages decreased from an average of 61% to 39%. 
- There was also a decline in the conversion rate from search to payment, dropping from an average of nearly 18% to 7%.

-> When comparing conversion rates across months by gender, female users generally showed slightly higher conversion rates than male users. However, both genders followed a similar trend in conversion rates over the months.

-> Additionally, when examining conversion rates across months by device type, it was observed that:
- Desktop users consistently had a conversion rate of nearly 50% from home to search every month. 
- In contrast, mobile users initially showed a high conversion rate of approximately 80% in the first two months, but this dropped significantly to around 20% in March and April. 
- Mobile users also had a better conversion rate from search to payment, approximately 20%, compared to desktop users, who saw a decline from 15% in the first two months to 4% in the next two.
- In the payment-to-confirmation stage, mobile users slightly outperformed desktop users.

### Recommendations:
#### Immediate:

-> A comprehensive website audit will help analyse the website's performance metrics to understand the issues encountered. Investigate events around March 1st. 
- Have there been any updates or changes to how users access the website via mobile? 
- Did these mobile-specific changes create friction or confusion for website users?
- Did these affect the page load time or server response time? How about overall website speed?
  
	- Conduct a thorough investigation into any technical issues that may have caused the noticeable drop in conversion rates around March 1st. Focus on page load time, server response time, and overall website performance.
	- Collaborate with the IT team to identify and address any backend or frontend issues possibly affecting user experience and conversion rates.

-> Watch session recordings, if possible, to understand how users failed to interact or progress around March 1st. Compare it with those who've progressed and interacted to understand differences in user journeys.
- Review elements used to navigate from one page to another. Are the page elements confusing/distracting? Is any unusual behaviour indicating broken page elements? Are the CTAs (call-to-action) clear?

-> Optimising homepage layout and search functionality.
- Optimise the homepage layout, content, and call-to-action buttons to encourage users to explore products through search. 
- Improve the search functionality, product filtering options, and product recommendations to help users find desired items easily. 
- Implement responsive design principles to ensure a seamless user experience across all devices. Adjust user interface elements, navigation and checkout flow for mobile users to streamline the purchasing process.

#### Nice to Haves:

-> Regularly compare the desktop and mobile versions of the website to ensure prominent elements are well placed.
- How far down the page do the users scroll?
- Where do desktop users click their mouse? Where do mobile users tap?
- Time spent viewing.

-> Setting up automated weekly monitoring to track conversion rates and other KPIs can help analyse and identify dips or spikes regularly.

-> Gather feedback from users frequently to gather insights.
- Include on-page surveys, feedback forms and open-ended feedback to perceive users' understanding of the website.
- Conducting usability testing can help understand the issues encountered, pain points and solutions users would like to see.

-> Send out automated and personalised email reminders for users who have abandoned their shopping carts.
- Offer incentives or discounts to encourage purchase completion.
- Review email campaigns and iterate on the content based on engagement and conversion rates.

-> Clear communication and messaging of the value proposition and unique selling proposition can help visitors and users tolerate inconsistencies and imperfections in the user experience.
- Inclusion of customer testimonials and reviews can help build trust.
- Conducting market research and understanding market trends can help refine and evolve the value proposition to meet customers' needs.

### SQL:
Find the SQL Script [here](https://github.com/umasreeakula/website_funnel_analysis/blob/main/website_funnel_analysis.sql).

I began by exploring the tables, starting with the Home Page Table (home_page_table). To quickly understand the data, I used a simple SELECT statement to view the first 100 rows, including all columns, to get an initial sense of the table's contents.
```
select 
	*
from 
	home_page_table
limit 100;
```
Next, to understand how large the table is, I assessed the dataset's size by using COUNT(*) to count the number of rows. Additionally, I examined the number of distinct values in each column using the COUNT(DISTINCT column_name) function to understand the data distribution across columns.
```
select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	home_page_table;
```
Given that each column had only one value, I checked for any missing values, finding none.
```
select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	home_page_table
where
	user_id is null or page is null;
```
I repeated this process for the Search Page (search_page_table), Payment Page (payment_page_table), and Payment Confirmation Tables (payment_confirmation_table) for a comprehensive understanding of the entire dataset.
```
-- Displaying the first 100 records (with all columns) from the search_page_table to get a glimpse of the data

select 
	*
from 
	search_page_table
limit 100;

-- Calculating the number of records, distinct users, and distinct pages

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	search_page_table;

-- Counting the number of missing values for user_id and page columns

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	search_page_table
where
	user_id is null or page is null;

-- Displaying the first 100 records (with all columns) from the payment_page_table to get a glimpse of the data

select 
	*
from 
	payment_page_table
limit 100;

-- Calculating the number of records, distinct users, and distinct pages

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	payment_page_table;

-- Counting the number of missing values for user_id and page columns

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	payment_page_table
where
	user_id is null or page is null;

-- Displaying the first 100 records (with all columns) from the payment_confirmation_table to get a glimpse of the data

select 
	*
from 
	payment_confirmation_table
limit 100;

-- Calculating the number of records, distinct users, and distinct pages

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	payment_confirmation_table;

-- Counting the number of missing values for user_id and page columns

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	payment_confirmation_table
where
	user_id is null or page is null;

-- Displaying the first 100 records (with all columns) from the user_table to get a glimpse of the data

select
	*
from 
	user_table
limit 100;
```
After viewing the user_table contents, I counted the number of rows, inspected the number of distinct values in the columns, and analysed the date range. The date was of the string type, so I used the CAST() function to convert it to a date type in the SELECT statement.
```
select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct cast(date as date)) as number_of_dates,
	min(cast(date as date)) as starting_date,
	max(cast(date as date)) as ending_date,
	count(distinct device) as number_of_devices,
	count(distinct sex) as sex
from
	user_table;
```
Given that the device and sex columns contained multiple distinct values, I used the COUNT() function alongside a GROUP BY clause to determine the most common values in these columns, followed by checking for any missing values.
```
select
	device,
	count(*) as occurrences
from
	user_table
group by
	device
order by
	occurrences desc;

select
	sex,
	count(*) as occurrences
from
	user_table
group by
	sex
order by
	occurrences desc;

-- Counting the number of missing values

select
	count(user_id) as missing_user_ids,
	count(date) as missing_dates,
	count(device) as missing_device,
	count(sex) as missing_sex
from
	user_table
where
	user_id is null or date is null or device is null or sex is null;
```
I verified my assumption by confirming that the users in the home_page_table matched those in the user_table. Using the INTERSECT clause, I identified the common user IDs from both tables and counted them to validate the overlap.
```
with common_users as (
	select user_id from home_page_table
		intersect
	select user_id from user_table)
	
select 
	count(*) as common_users_count
from
	common_users;
```
To unify the details of the users and the pages they've accessed,
 
- I used the UNION ALL clause and combined the user ID and page details of all four (home, search, payment, and payment confirmation) tables into a single view called "all_pages_view". 
- I created a new view called "page_landings_view" using the previously created "all_pages_view." This view summarises user engagements with different pages using a pivot table approach, using SUM() with CASE WHEN. Each page has a corresponding flag column indicating whether the user accessed that page (1) or not (0). The view aggregates this information for each user, grouping the data by user ID, making it convenient to analyse and understand user behaviour and interactions at a glance.
- Next, I created a view called "user_page_journey_view" by joining the "page_landings_view" with the "user_table" on the user ID. I used CAST() to convert the date column from a string to a date type and use it as a date for further analysis.
```
-- Combining all the page tables (home_page_table, search_page_table, payment_page_table, and payment_confirmation_table) into a single view using UNION ALL

drop view if exists all_pages_view;

create view all_pages_view as
	select
		user_id,
		page
	from
		home_page_table
	union all
	select
		user_id,
		page
	from
		search_page_table
	union all
	select
		user_id,
		page
	from
		payment_page_table
	union all
	select
		user_id,
		page
	from
		payment_confirmation_table;
	
-- Creating a pivot table to summarise user engagements with different pages
	
drop view if exists page_landings_view;

-- Creating a view named page_landings_view to store the pivot table results

create view page_landings_view as
	select 
		user_id,
		sum(case
			when page = 'home_page' then 1 else 0
			end) as home_page_flag,
		sum(case
			when page = 'search_page' then 1 else 0
			end) as search_page_flag,
		sum(case
			when page = 'payment_page' then 1 else 0
			end) as payment_page_flag,
		sum(case
			when page = 'payment_confirmation_page' then 1 else 0
			end) as payment_confirmation_flag
from
		all_pages_view
group by
		user_id;
		
-- Creating a final dataset view that combines user details and pages visited by them
	
drop view if exists user_page_journey_view;

-- Creating a view named user_page_journey_view to store the joined data of user details and page engagements

create view user_page_journey_view as
	select 
		u.user_id as user_id,
		home_page_flag,
		search_page_flag,
		payment_page_flag,
		payment_confirmation_flag,
		cast(date as date),
		device,
		sex
from 
		page_landings_view pv join user_table u on pv.user_id = u.user_id;
```
The final view includes information about user engagements with various pages (home, search, payment, payment confirmation) and details such as the date of engagement, device used, and user demographics like sex, giving a comprehensive view of each user's information and journey across different pages.

I utilised CASE WHEN statements within SUM() functions to understand user demographics and device preferences within the dataset comprehensively.

- For gender distribution,
	I counted the number of female and male users separately.
- For device distribution,
	I counted the number of users on desktop and mobile devices.
- For a detailed breakdown by gender and device type,
	I counted the number of users based on gender and device type, 	distinguishing between female and male users on desktop and mobile devices.
```
-- Calculating the total number of users by gender from the user_page_journey_view
	
select
	sum(case when sex = 'Female' then 1 end) as number_of_female_users,
	sum(case when sex = 'Male' then 1 end) as number_of_male_users
from
	user_page_journey_view;

-- Calculating the total number of users by device type from the user_page_journey_view
	
select
	sum(case when device = 'Desktop' then 1 end) as number_of_desktop_users,
	sum(case when device = 'Mobile' then 1 end) as number_of_mobile_users
from
	user_page_journey_view;

-- Calculating the total number of users by gender and device type from the user_page_journey_view
	
select
	sum(case when sex = 'Female' and device = 'Desktop' then 1 else 0 end) as female_desktop_users,
	sum(case when sex = 'Female' and device = 'Mobile' then 1 else 0 end) as female_mobile_users,
	sum(case when sex = 'Male' and device = 'Desktop' then 1 else 0 end) as male_desktop_users,
	sum(case when sex = 'Male' and device = 'Mobile' then 1 else 0 end) as male_mobile_users
from
	user_page_journey_view;
```
To get insights into the distribution of user signups over time and to verify if the decrease in conversion rates was due to low signups:

- I calculated the number of user signups on each engagement or activity date.
- For each engagement month, I calculated the total number of signups, average signups per day, and minimum and maximum signups.
	- The CTE daily_sign_ups computes the number of user signups for each engagement date.
	- The main query then aggregates this data by month, calculating the total (SUM), average (AVG), minimum (MIN), and maximum (MAX) number of user signups for each month. In this query, I also utilised EXTRACT() to retrieve the month number from the engagement date. Then, I employed TO_CHAR() to convert this number into the month name for better readability. Additionally, I applied TO_DATE() within the ORDER BY clause to display chronologically ordered results by month.
```
-- Counting the number of user signups on each engagement/activity date

select
	date as engagement_date,
	count(user_id) as signed_up_users_count
from
	user_page_journey_view
group by
	date;

-- Number of Users Stats by Engagement Month

-- Total, Average, Minimum, Maximum Number of Users Signups, by Engagement Month

with daily_sign_ups as (
	select
		date as engagement_date,
		count(user_id) as signed_up_users_count
	from
		user_page_journey_view
	group by
		date)
		
select
	to_char(to_date(extract(month from engagement_date)::text, 'MM'), 'Month') as engagement_month,
	sum(signed_up_users_count) as signed_up_users_count,
	round(avg(signed_up_users_count)) as avg_signups,
	min(signed_up_users_count) as min_signups,
	max(signed_up_users_count) as max_signups
from
	daily_sign_ups
group by
	to_char(to_date(extract(month from engagement_date)::text, 'MM'), 'Month')
order by
	to_date(to_char(to_date(extract(month from engagement_date)::text, 'MM'), 'Month'), 'Month');
```
For analysis and insights into the overall user journey in progressing towards the final conversion goal (making a purchase), I calculated conversion rates between each stage of the conversion funnel (home - search > search - payment > payment - confirmation of payment) using a nested common table expression (CTE).

- The CTE total_page_landings_cte computes the total number of users who visited each page in the conversion funnel using the CASE WHEN() with the SUM() function.
- In the CTE conversion_rates_cte, each subquery calculates the conversion rate by dividing the number of users who reached the subsequent stage by the number of users who reached the previous stage, multiplying by 100 for percentage representation, and rounding to two decimal places, along with a description of the funnel stage in the funnel_stage and funnel_stage_name columns.
- The main query then selects and presents the funnel stage, funnel stage name, and conversion rate from the common table expression conversion_rates_cte.
```
-- Calculating the total number of users who visited each page in the conversion funnel, followed by conversion rates between each stage of the funnel
	
-- First CTE Expression (total_page_landings_cte) calculates total number of users who visited each page

with total_page_landings_cte as (
	select
		sum(case when home_page_flag = 1 then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as payment_confirmation_users
	from
		user_page_journey_view
),

-- Second CTE Expression (conversion_rates_cte) calculates the conversion rates between each stage

    conversion_rates_cte as (
	select
		1 as funnel_stage,
		'home -> search' as funnel_stage_name,
		round(cast(search_page_users as numeric) / home_page_users * 100, 2) as conversion_rate
	from 
		total_page_landings_cte
	union all
	select
		2 as funnel_stage,
		'search -> payment' as funnel_stage_name,
		round(cast(payment_page_users as numeric) / search_page_users * 100, 2) as conversion_rate
	from 
		total_page_landings_cte
	union all
	select
		3 as funnel_stage,
		'payment -> confirmation of payment' as funnel_stage_name,
		round(cast(payment_confirmation_users as numeric) / payment_page_users * 100, 2) as conversion_rate
	from 
		total_page_landings_cte
	order by
		funnel_stage
	)
	
select 
	funnel_stage,
	funnel_stage_name,
	conversion_rate
from 
	conversion_rates_cte;
```
Similarly, I also analysed conversion rates in the conversion funnel based on sex and device type, calculating conversion rates between stages of the funnel for both female and male users, followed by conversion rates between each stage of the funnel for desktop and mobile users.
```
-- Calculating the total number of users who visited each page in the conversion funnel, followed by conversion rates between each stage of the funnel, by gender/sex
	
-- First CTE for calculating the users by gender for each page

with gender_total_page_landings_cte as (
	select
		sum(case when home_page_flag = 1 and sex = 'Female' then 1 else 0 end) as female_home_page_users,
		sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) as female_search_page_users,
		sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) as female_payment_page_users,
		sum(case when payment_confirmation_flag = 1 and sex = 'Female' then 1 else 0 end) as female_payment_confirmation_users,
		sum(case when home_page_flag = 1 and sex = 'Male' then 1 else 0 end) as male_home_page_users,
		sum(case when search_page_flag = 1 and sex = 'Male' then 1 else 0 end) as male_search_page_users,
		sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) as male_payment_page_users,
		sum(case when payment_confirmation_flag = 1 and sex = 'Male' then 1 else 0 end) as male_payment_confirmation_users
	from
		user_page_journey_view
),

-- Second CTE calculating conversion rates

	gender_conversion_rates_cte as (
	select
		'Female' as sex,
		1 as funnel_stage,
		'home -> search' as funnel_stage_name,
		round(cast(female_search_page_users as numeric) / female_home_page_users * 100, 2) as conversion_rate
	from 
		gender_total_page_landings_cte
	union all
	select
		'Male' as sex,
		1 as funnel_stage,
		'home -> search' as funnel_stage_name,
		round(cast(male_search_page_users as numeric) / male_home_page_users * 100, 2) as conversion_rate
	from 
		gender_total_page_landings_cte
	union all
	select
		'Female' as sex,
		2 as funnel_stage,
		'search -> payment' as funnel_stage_name,
		round(cast(female_payment_page_users as numeric) / female_search_page_users * 100, 2) as conversion_rate
	from 
		gender_total_page_landings_cte
	union all
	select
		'Male' as sex,
		2 as funnel_stage,
		'search -> payment' as funnel_stage_name,
		round(cast(male_payment_page_users as numeric) / male_search_page_users * 100, 2) as conversion_rate
	from 
		gender_total_page_landings_cte
	union all
	select
		'Female' as sex,
		3 as funnel_stage,
		'payment -> confirmation of payment' as funnel_stage_name,
		round(cast(female_payment_confirmation_users as numeric) / female_payment_page_users * 100, 2) as conversion_rate
	from 
		gender_total_page_landings_cte
	union all
	select
		'Male' as sex,
		3 as funnel_stage,
		'payment -> confirmation of payment' as funnel_stage_name,
		round(cast(male_payment_confirmation_users as numeric) / male_payment_page_users * 100, 2) as conversion_rate
	from 
		gender_total_page_landings_cte
	order by
		funnel_stage)

select
	sex,
	funnel_stage,
	funnel_stage_name,
	conversion_rate
from 
	gender_conversion_rates_cte;

-- Calculating the total number of users who visited each page in the conversion funnel, followed by conversion rates between each stage of the funnel, by device type
	
-- First CTE for calculating the users by device type for each page

with device_total_page_landings_cte as (
	select
		sum(case when home_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as desktop_home_page_users,
		sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as desktop_search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as desktop_payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Desktop' then 1 else 0 end) as desktop_payment_confirmation_users,
		sum(case when home_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as mobile_home_page_users,
		sum(case when search_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as mobile_search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as mobile_payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Mobile' then 1 else 0 end) as mobile_payment_confirmation_users
	from
		user_page_journey_view
),

-- Second CTE calculating conversion rates for each device type

	device_conversion_rates_cte as (
	select
		'Desktop' as device,
		1 as funnel_stage,
		'home -> search' as funnel_stage_name,
		round(cast(desktop_search_page_users as numeric) / desktop_home_page_users * 100, 2) as conversion_rate
	from 
		device_total_page_landings_cte
	union all
	select
		'Mobile' as device,
		1 as funnel_stage,
		'home -> search' as funnel_stage_name,
		round(cast(mobile_search_page_users as numeric) / mobile_home_page_users * 100, 2) as conversion_rate
	from 
		device_total_page_landings_cte
	union all
	select
		'Desktop' as device,
		2 as funnel_stage,
		'search -> payment' as funnel_stage_name,
		round(cast(desktop_payment_page_users as numeric) / desktop_search_page_users * 100, 2) as conversion_rate
	from 
		device_total_page_landings_cte
	union all
	select
		'Mobile' as device,
		2 as funnel_stage,
		'search -> payment' as funnel_stage_name,
		round(cast(mobile_payment_page_users as numeric) / mobile_search_page_users * 100, 2) as conversion_rate
	from 
		device_total_page_landings_cte
	union all
	select
		'Desktop' as device,
		3 as funnel_stage,
		'payment -> confirmation of payment' as funnel_stage_name,
		round(cast(desktop_payment_confirmation_users as numeric) / desktop_payment_page_users * 100, 2) as conversion_rate
	from 
		device_total_page_landings_cte
	union all
	select
		'Mobile' as device,
		3 as funnel_stage,
		'payment -> confirmation of payment' as funnel_stage_name,
		round(cast(mobile_payment_confirmation_users as numeric) / mobile_payment_page_users * 100, 2) as conversion_rate
	from 
		device_total_page_landings_cte
	order by
		funnel_stage)
select
	device,
	funnel_stage,
	funnel_stage_name,
	conversion_rate
from
	device_conversion_rates_cte;
```
Next, I calculated the monthly user landings on different pages and their corresponding conversion rates:

- The EXTRACT function extracts the month from the date column, representing the signup month.
- For each month:
	- I calculated the number of users landing on the home page, search page, payment page, and payment confirmation page within the CTE.
	- Then, computed conversion rates for each stage of the funnel:
		- Conversion rate from the home page to the search page (conversion_rate_one).
		- Conversion rate from the search page to the payment page (conversion_rate_two).
		- Conversion rate from the payment page to the payment confirmation page (conversion_rate_three)
```
with monthly_landings_cte as (
	select 
		extract(month from date) as signup_month,
		sum(case when home_page_flag = 1 then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		extract(month from date))
		
select
	to_char(to_date(signup_month::text, 'MM'), 'Month') as signup_month,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from 
	monthly_landings_cte;
```
Similarly, I also calculated page landings by the week and by the activity day.
```
-- Calculating weekly user landings on different pages and their corresponding conversion rates

with weekly_landings_cte as (
	select 
		extract(week from date) as signup_week,
		sum(case when home_page_flag = 1 then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		extract(week from date))
		
select
	signup_week,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from 
	weekly_landings_cte;

-- Calculating daily user landings on different pages and their corresponding conversion rates

with daily_landings_cte as (
	select 
		date as signup_date,
		sum(case when home_page_flag = 1 then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		date)
		
select
	signup_date,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from 
	daily_landings_cte;
```
I used the same logic and calculated the monthly, weekly and daily page landings and the conversion rates of the funnel stages for both the sex groups (male and female) and the device types (desktop and mobile).
```
-- Calculating monthly user landings on different pages and their corresponding conversion rates, by gender/sex

with gender_monthly_landings_cte as (
	select 
		extract(month from date) as signup_month,
		'Female' as sex,
		sum(case when home_page_flag = 1 and sex = 'Female' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		extract(month from date)
	union all
	select 
		extract(month from date) as signup_month,
		'Male' as sex,
		sum(case when home_page_flag = 1 and sex = 'Male' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and sex = 'Male' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		extract(month from date)
	order by
		signup_month, sex
	)
	
select
	to_char(to_date(signup_month::text, 'MM'), 'Month') as signup_month,
	sex,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	gender_monthly_landings_cte;
	
-- Calculating weekly user landings on different pages and their corresponding conversion rates, by gender/sex

with gender_weekly_landings_cte as (
	select 
		extract(week from date) as signup_week,
		'Female' as sex,
		sum(case when home_page_flag = 1 and sex = 'Female' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		extract(week from date)
	union all
	select 
		extract(week from date) as signup_week,
		'Male' as sex,
		sum(case when home_page_flag = 1 and sex = 'Male' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and sex = 'Male' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		extract(week from date)
	order by
		signup_week, sex
	)
	
select
	signup_week,
	sex,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	gender_weekly_landings_cte;

-- Calculating daily user landings on different pages and their corresponding conversion rates, by gender/sex

with gender_daily_landings_cte as (
	select 
		date as signup_date,
		'Female' as sex,
		sum(case when home_page_flag = 1 and sex = 'Female' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		date
	union all
	select 
		date as signup_date,
		'Male' as sex,
		sum(case when home_page_flag = 1 and sex = 'Male' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and sex = 'Male' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		date
	order by
		signup_date, sex
	)
	
select
	signup_date,
	sex,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	gender_daily_landings_cte;
	
-- Calculating monthly user landings on different pages and their corresponding conversion rates, by device type

with device_monthly_landings_cte as (
	select
		extract(month from date) as signup_month,
		'Desktop' as device,
		sum(case when home_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		extract(month from date)
	union all
	select
		extract(month from date) as signup_month,
		'Mobile' as device,
		sum(case when home_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		extract(month from date)
	order by
		signup_month, device
	)
	
select
	to_char(to_date(signup_month::text, 'MM'), 'Month') as signup_month,
	device,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	device_monthly_landings_cte;

-- Calculating weekly user landings on different pages and their corresponding conversion rates, by device type

with device_weekly_landings_cte as (
	select
		extract(week from date) as signup_week,
		'Desktop' as device,
		sum(case when home_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		extract(week from date)
	union all
	select
		extract(week from date) as signup_week,
		'Mobile' as device,
		sum(case when home_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		extract(week from date)
	order by
		signup_week, device
	)
	
select
	signup_week,
	device,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	device_weekly_landings_cte;
	
-- Calculating daily user landings on different pages and their corresponding conversion rates, by device type

with device_daily_landings_cte as (
	select
		date as signup_date,
		'Desktop' as device,
		sum(case when home_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		date
	union all
	select
		date as signup_date,
		'Mobile' as device,
		sum(case when home_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		date
	order by
		signup_date, device
	)
	
select
	signup_date,
	device,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	device_daily_landings_cte;
```
Finally, to analyse conversion rates for different groups based on both sex and device type, I followed the previous approach. By considering combinations such as Female + Desktop, Female + Mobile, Male + Desktop, and Male + Mobile, I created a more detailed breakdown of user engagement and conversion rates across the funnel for the groups. 
- I used the NULLIF() function to deal with the divide-by-zero error (sometimes, no users belonged to a particular combination of sex + device type) and COALESCE() to display the result as 0 in this case.

This analysis enabled a deeper understanding of how user behaviour varies based on sex only, device type only and sex and device type.
```
with device_gender_daily_landings_cte as (
	select
		date as signup_date,
		'Desktop' as device,
		'Female' as sex,
		sum(case when home_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		date
	union all
	select 
		date as signup_date,
		'Mobile' as device,
		'Female' as sex,
		sum(case when home_page_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		date
	union all
	select
		date as signup_date,
		'Desktop' as device,
		'Male' as sex,
		sum(case when home_page_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		date
	union all
	select 
		date as signup_date,
		'Mobile' as device,
		'Male' as sex,
		sum(case when home_page_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end) as payment_confirmation_users
	from 
		user_page_journey_view
	group by
		date
	order by 
		signup_date, device, sex
	)
	
select
	signup_date,
	device,
	sex,
	coalesce(round(1.0 * search_page_users / nullif(home_page_users, 0) * 100, 2), 0) as conversion_rate_one,
	coalesce(round(1.0 * payment_page_users / nullif(search_page_users, 0) * 100, 2), 0) as conversion_rate_two,
	coalesce(round(1.0 * payment_confirmation_users / nullif(payment_page_users, 0) * 100, 2), 0) as conversion_rate_three
from
	device_gender_daily_landings_cte;
```

 #### Notes:
 - In this project, users and sessions are used interchangeably, despite their differing definitions in the real world. The assumption is that each user ID represents a user accessing the website only once, resulting in only one session per user.
 - Conversion Rate Calculation: (Total # of Users who reached subsequent stage of funnel / Total # of Users from previous funnel stage) * 100

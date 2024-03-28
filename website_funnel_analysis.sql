-- Checking for the number of records, duplicates or inconsistencies and any missing values in each table

-- Displaying the first 5 records from the home_page_table to get a glimpse of the data

select 
	user_id,
	page
from 
	home_page_table
limit 5;

-- Calculating the number of records, distinct users, and distinct pages

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	home_page_table;

-- Counting the number of missing values for user_id and page columns

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	home_page_table
where
	user_id is null or page is null;

-- -- Displaying the first 5 records from the search_page_table to get a glimpse of the data

select 
	user_id,
	page
from 
	search_page_table
limit 5;

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

-- Displaying the first 5 records from the payment_page_table to get a glimpse of the data

select 
	user_id,
	page
from 
	payment_page_table
limit 5;

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

-- Displaying the first 5 records from the payment_confirmation_table to get a glimpse of the data

select 
	user_id,
	page
from 
	payment_confirmation_table
limit 5;

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

-- Displaying the first 5 records from the user_table to get a glimpse of the data

select 
	user_id,
	date,
	device,
	sex
from 
	user_table
limit 5;

-- Calculating the number of records, distinct users, distinct devices and looking for inconsistencies in date and sex columns

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

-- Ensuring that the number of users between the home_page_table and the user_table is consistent

select 
	count(*) as common_users_count
from
	(select user_id from home_page_table
	intersect
	select user_id from user_table) as common_users;

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
	
-- Creating a pivot table to summarize user engagements with different pages
	
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


-- Descriptive Stats for daily landings on home page by the month

-- Defining a CTE to calculate the daily number of users landing on the home page by date

with daily_users as (
	select
		date as signup_date,
		sum(case when home_page_flag = 1 then 1 else 0 end) as users
	from
		user_page_journey_view
	group by
		date
),

-- Adding details such as row numbers and total number of days with user engagement within each month

details as (
	select
		signup_date,
		users,
		row_number() over (partition by extract(month from signup_date) order by users) as row_number,
		sum(1) over (partition by extract(month from signup_date)) as total
	from
		daily_users
),

-- Calculating quartiles (Q1, median, Q3) for each month's user engagement on the home page

quartiles as (
select
	signup_date,
	users,
	round(avg(case when row_number >= (floor(total / 2.0)/ 2.0) 
                     and row_number <= (floor(total / 2.0)/ 2.0) + 1 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as q1,
	round(avg(case when row_number >= (total / 2.0) 
                     and row_number <= (total / 2.0) + 1 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as median,
	round(avg(case when row_number >= (ceil(total / 2.0) + (floor(total / 2.0)/ 2.0))
                     and row_number <= (ceil(total / 2.0) + (floor(total / 2.0)/ 2.0) + 1) 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as q3
from
	details
)

-- Computing descriptive statistics for daily landings on the home page by month

select
	extract(month from signup_date) as signup_month,
	min(users) as minimum_users_landed,
	round(avg(q1)) as q1,
	round(avg(median)) as median,
	round(avg(q3))as q3,
	max(users) as maximum_users_landed,
	round(avg(users)) as average_users_landed,
	round(stddev(users), 2) as standard_deviation
from
	quartiles
group by
	extract(month from signup_date);

-- Descriptive Stats for daily landings on search page by the month

-- Defining a CTE to calculate the daily number of users landing on the search page by date

with daily_users as (
	select
		date as signup_date,
		sum(case when search_page_flag = 1 then 1 else 0 end) as users
	from
		user_page_journey_view
	group by
		date
),

-- Adding details such as row numbers and total number of days with user engagement within each month

details as (
	select
		signup_date,
		users,
		row_number() over (partition by extract(month from signup_date) order by users) as row_number,
		sum(1) over (partition by extract(month from signup_date)) as total
	from
		daily_users
),

-- Calculating quartiles (Q1, median, Q3) for each month's user engagement on the search page

quartiles as (
select
	signup_date,
	users,
	round(avg(case when row_number >= (floor(total / 2.0)/ 2.0) 
                     and row_number <= (floor(total / 2.0)/ 2.0) + 1 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as q1,
	round(avg(case when row_number >= (total / 2.0) 
                     and row_number <= (total / 2.0) + 1 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as median,
	round(avg(case when row_number >= (ceil(total / 2.0) + (floor(total / 2.0)/ 2.0))
                     and row_number <= (ceil(total / 2.0) + (floor(total / 2.0)/ 2.0) + 1) 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as q3
from
	details
)

-- Computing descriptive statistics for daily landings on the search page by month

select
	extract(month from signup_date) as signup_month,
	min(users) as minimum_users_landed,
	round(avg(q1)) as q1,
	round(avg(median)) as median,
	round(avg(q3))as q3,
	max(users) as maximum_users_landed,
	round(avg(users)) as average_users_landed,
	round(stddev(users), 2) as standard_deviation
from
	quartiles
group by
	extract(month from signup_date);

-- Descriptive Stats for daily landings on payment page by the month

-- Defining a CTE to calculate the daily number of users landing on the payment page by date

with daily_users as (
	select
		date as signup_date,
		sum(case when payment_page_flag = 1 then 1 else 0 end) as users
	from
		user_page_journey_view
	group by
		date
),

-- Adding details such as row numbers and total number of days with user engagement within each month

details as (
	select
		signup_date,
		users,
		row_number() over (partition by extract(month from signup_date) order by users) as row_number,
		sum(1) over (partition by extract(month from signup_date)) as total
	from
		daily_users
),

-- Calculating quartiles (Q1, median, Q3) for each month's user engagement on the payment page

quartiles as (
select
	signup_date,
	users,
	round(avg(case when row_number >= (floor(total / 2.0)/ 2.0) 
                     and row_number <= (floor(total / 2.0)/ 2.0) + 1 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as q1,
	round(avg(case when row_number >= (total / 2.0) 
                     and row_number <= (total / 2.0) + 1 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as median,
	round(avg(case when row_number >= (ceil(total / 2.0) + (floor(total / 2.0)/ 2.0))
                     and row_number <= (ceil(total / 2.0) + (floor(total / 2.0)/ 2.0) + 1) 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as q3
from
	details
)

-- Computing descriptive statistics for daily landings on the payment page by month

select
	extract(month from signup_date) as signup_month,
	min(users) as minimum_users_landed,
	round(avg(q1)) as q1,
	round(avg(median)) as median,
	round(avg(q3))as q3,
	max(users) as maximum_users_landed,
	round(avg(users)) as average_users_landed,
	round(stddev(users), 2) as standard_deviation
from
	quartiles
group by
	extract(month from signup_date);

-- Descriptive Stats for daily landings on payment confirmation page by the month

-- Defining a CTE to calculate the daily number of users landing on the payment confirmation page by date

with daily_users as (
	select
		date as signup_date,
		sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as users
	from
		user_page_journey_view
	group by
		date
),

-- Adding details such as row numbers and total number of days with user engagement within each month

details as (
	select
		signup_date,
		users,
		row_number() over (partition by extract(month from signup_date) order by users) as row_number,
		sum(1) over (partition by extract(month from signup_date)) as total
	from
		daily_users
),

-- Calculating quartiles (Q1, median, Q3) for each month's user engagement on the payment confirmation page

quartiles as (
select
	signup_date,
	users,
	round(avg(case when row_number >= (floor(total / 2.0)/ 2.0) 
                     and row_number <= (floor(total / 2.0)/ 2.0) + 1 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as q1,
	round(avg(case when row_number >= (total / 2.0) 
                     and row_number <= (total / 2.0) + 1 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as median,
	round(avg(case when row_number >= (ceil(total / 2.0) + (floor(total / 2.0)/ 2.0))
                     and row_number <= (ceil(total / 2.0) + (floor(total / 2.0)/ 2.0) + 1) 
                    then users / 1.0 else null end
               ) over (partition by extract(month from signup_date)), 2) as q3
from
	details
)

-- Computing descriptive statistics for daily landings on the payment confirmation page by month

select
	extract(month from signup_date) as signup_month,
	min(users) as minimum_users_landed,
	round(avg(q1)) as q1,
	round(avg(median)) as median,
	round(avg(q3))as q3,
	max(users) as maximum_users_landed,
	round(avg(users)) as average_users_landed,
	round(stddev(users), 2) as standard_deviation
from
	quartiles
group by
	extract(month from signup_date);
	
-- Conversion Rates
	
-- Calculating the total number of users who visited each page in the conversion funnel, followed by conversion rates between each stage of the funnel
	
with total_page_landings_cte as (
	select
		sum(case when home_page_flag = 1 then 1 else 0 end) as home_page_users,
		sum(case when search_page_flag = 1 then 1 else 0 end) as search_page_users,
		sum(case when payment_page_flag = 1 then 1 else 0 end) as payment_page_users,
		sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as payment_confirmation_users
	from
		user_page_journey_view
)

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
	funnel_stage;
		
-- Calculating the total number of users who visited each page in the conversion funnel, followed by conversion rates between each stage of the funnel, by gender/sex
	
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
)
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
	funnel_stage;

-- Calculating the total number of users who visited each page in the conversion funnel, followed by conversion rates between each stage of the funnel, by device type
	
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
)
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
	funnel_stage;

-- Calculating monthly user landings on different pages and their corresponding conversion rates

select 
	extract(month from date) as signup_month,
	sum(case when home_page_flag = 1 then 1 else 0 end) as home_page_users,
	sum(case when search_page_flag = 1 then 1 else 0 end) as search_page_users,
	round(cast(sum(case when search_page_flag = 1 then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 then 1 else 0 end) * 100, 2) as conversion_rate_three
from 
	user_page_journey_view
group by
	extract(month from date);

-- Calculating weekly user landings on different pages and their corresponding conversion rates

select 
	extract(week from date) as signup_week,
	sum(case when home_page_flag = 1 then 1 else 0 end) as home_page_users,
	sum(case when search_page_flag = 1 then 1 else 0 end) as search_page_users,
	round(cast(sum(case when search_page_flag = 1 then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 then 1 else 0 end) * 100, 2) as conversion_rate_three
from 
	user_page_journey_view
group by
	extract(week from date);

-- Calculating daily user landings on different pages and their corresponding conversion rates

select 
	date as signup_date,
	sum(case when home_page_flag = 1 then 1 else 0 end) as home_page_users,
	sum(case when search_page_flag = 1 then 1 else 0 end) as search_page_users,
	round(cast(sum(case when search_page_flag = 1 then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 then 1 else 0 end) * 100, 2) as conversion_rate_three
from 
	user_page_journey_view
group by
	date;

-- Calculating monthly user landings on different pages and their corresponding conversion rates, by gender/sex

select 
	extract(month from date) as signup_month,
	'Female' as sex,
	sum(case when home_page_flag = 1 and sex = 'Female' then 1 else 0 end) as home_page_users,
	sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) as search_page_users,
	round(cast(sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and sex = 'Female' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and sex = 'Female' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) * 100, 2) as conversion_rate_three
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
	round(cast(sum(case when search_page_flag = 1 and sex = 'Male' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and sex = 'Male' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and sex = 'Male' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and sex = 'Male' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) * 100, 2) as conversion_rate_three
from 
	user_page_journey_view
group by
	extract(month from date)
order by 
	signup_month, sex;
	
-- Calculating weekly user landings on different pages and their corresponding conversion rates, by gender/sex

select 
	extract(week from date) as signup_week,
	'Female' as sex,
	sum(case when home_page_flag = 1 and sex = 'Female' then 1 else 0 end) as home_page_users,
	sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) as search_page_users,
	round(cast(sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and sex = 'Female' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and sex = 'Female' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) * 100, 2) as conversion_rate_three
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
	round(cast(sum(case when search_page_flag = 1 and sex = 'Male' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and sex = 'Male' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and sex = 'Male' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and sex = 'Male' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) * 100, 2) as conversion_rate_three
from 
	user_page_journey_view
group by
	extract(week from date)
order by 
	signup_week, sex;
	
-- Calculating daily user landings on different pages and their corresponding conversion rates, by gender/sex

select 
	date as signup_date,
	'Female' as sex,
	sum(case when home_page_flag = 1 and sex = 'Female' then 1 else 0 end) as home_page_users,
	sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) as search_page_users,
	round(cast(sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and sex = 'Female' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and sex = 'Female' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and sex = 'Female' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and sex = 'Female' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and sex = 'Female' then 1 else 0 end) * 100, 2) as conversion_rate_three
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
	round(cast(sum(case when search_page_flag = 1 and sex = 'Male' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and sex = 'Male' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and sex = 'Male' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and sex = 'Male' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and sex = 'Male' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and sex = 'Male' then 1 else 0 end) * 100, 2) as conversion_rate_three
from 
	user_page_journey_view
group by
	date
order by 
	signup_date, sex;
	
-- Calculating monthly user landings on different pages and their corresponding conversion rates, by device type

select 
	extract(month from date) as signup_month,
	'Desktop' as device,
	sum(case when home_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as home_page_users,
	sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as search_page_users,
	round(cast(sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and device = 'Desktop' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and device = 'Desktop' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) * 100, 2) as conversion_rate_three
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
	round(cast(sum(case when search_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and device = 'Mobile' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and device = 'Mobile' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and device = 'Mobile' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) * 100, 2) as conversion_rate_three
from 
	user_page_journey_view
group by
	extract(month from date)
order by 
	signup_month, device;

-- Calculating weekly user landings on different pages and their corresponding conversion rates, by device type

select 
	extract(week from date) as signup_week,
	'Desktop' as device,
	sum(case when home_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as home_page_users,
	sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as search_page_users,
	round(cast(sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and device = 'Desktop' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and device = 'Desktop' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) * 100, 2) as conversion_rate_three
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
	round(cast(sum(case when search_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and device = 'Mobile' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and device = 'Mobile' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and device = 'Mobile' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) * 100, 2) as conversion_rate_three
from 
	user_page_journey_view
group by
	extract(week from date)
order by 
	signup_week, device;
	
-- Calculating daily user landings on different pages and their corresponding conversion rates, by device type

select 
	date as signup_date,
	'Desktop' as device,
	sum(case when home_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as home_page_users,
	sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as search_page_users,
	round(cast(sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and device = 'Desktop' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and device = 'Desktop' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and device = 'Desktop' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and device = 'Desktop' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and device = 'Desktop' then 1 else 0 end) * 100, 2) as conversion_rate_three
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
	round(cast(sum(case when search_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as numeric) / sum(case when home_page_flag = 1 and device = 'Mobile' then 1 else 0 end) * 100, 2) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_page_users,
	round(cast(sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) as numeric) / sum(case when search_page_flag = 1 and device = 'Mobile' then 1 else 0 end) * 100, 2) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and device = 'Mobile' then 1 else 0 end) as payment_confirmation_users,
	round(cast(sum(case when payment_confirmation_flag = 1 and device = 'Mobile' then 1 else 0 end) as numeric) / sum(case when payment_page_flag = 1 and device = 'Mobile' then 1 else 0 end) * 100, 2) as conversion_rate_three
from 
	user_page_journey_view
group by
	date
order by 
	signup_date, device;
	
-- Calculating daily user landings on different pages and their corresponding conversion rates, by gender/sex and device type

select 
	date as signup_date,
	'Desktop' as device,
	'Female' as sex,
	sum(case when home_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as home_page_users,
	sum(case when search_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as search_page_users,
	coalesce(round(cast(sum(case when search_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as numeric) / nullif(sum(case when home_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as payment_page_users,
	coalesce(round(cast(sum(case when payment_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as numeric) / nullif(sum(case when search_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as payment_confirmation_users,
	coalesce(round(cast(sum(case when payment_confirmation_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end) as numeric) / nullif(sum(case when payment_page_flag = 1 and device = 'Desktop' and sex = 'Female' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_three
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
	coalesce(round(cast(sum(case when search_page_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end) as numeric) / nullif(sum(case when home_page_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end) as payment_page_users,
	coalesce(round(cast(sum(case when payment_page_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end) as numeric) / nullif(sum(case when search_page_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end) as payment_confirmation_users,
	coalesce(round(cast(sum(case when payment_confirmation_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end) as numeric) / nullif(sum(case when payment_page_flag = 1 and device = 'Mobile' and sex = 'Female' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_three
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
	coalesce(round(cast(sum(case when search_page_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end) as numeric) / nullif(sum(case when home_page_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end) as payment_page_users,
	coalesce(round(cast(sum(case when payment_page_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end) as numeric) / nullif(sum(case when search_page_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end) as payment_confirmation_users,
	coalesce(round(cast(sum(case when payment_confirmation_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end) as numeric) / nullif(sum(case when payment_page_flag = 1 and device = 'Desktop' and sex = 'Male' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_three
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
	coalesce(round(cast(sum(case when search_page_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end) as numeric) / nullif(sum(case when home_page_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_one,
	sum(case when payment_page_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end) as payment_page_users,
	coalesce(round(cast(sum(case when payment_page_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end) as numeric) / nullif(sum(case when search_page_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_two,
	sum(case when payment_confirmation_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end) as payment_confirmation_users,
	coalesce(round(cast(sum(case when payment_confirmation_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end) as numeric) / nullif(sum(case when payment_page_flag = 1 and device = 'Mobile' and sex = 'Male' then 1 else 0 end), 0) * 100, 2), 0) as conversion_rate_three
from 
	user_page_journey_view
group by
	date
order by 
	signup_date, device, sex;
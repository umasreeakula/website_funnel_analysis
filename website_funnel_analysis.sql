-- Checking for the number of records, duplicates or inconsistencies and any missing values in each table

-- Home Page

select 
	*
from 
	home_page_table
limit 5;

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	home_page_table;

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	home_page_table
where
	user_id is null or page is null;

-- Search Page

select 
	*
from 
	search_page_table
limit 5;

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	search_page_table;

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	search_page_table
where
	user_id is null or page is null;

-- Payment Page

select 
	*
from 
	payment_page_table
limit 5;

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	payment_page_table;

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	payment_page_table
where
	user_id is null or page is null;

-- Payment Confirmation Page

select 
	*
from 
	payment_confirmation_table
limit 5;

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	payment_confirmation_table;

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	payment_confirmation_table
where
	user_id is null or page is null;

-- User table 

select 
	*
from 
	user_table
limit 5;

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

select
	count(user_id) as missing_user_ids,
	count(date) as missing_dates,
	count(device) as missing_device,
	count(sex) as missing_sex
from
	user_table
where
	user_id is null or date is null or device is null or sex is null;

-- Verifying the number of common users in the tables

select 
	count(*) as common_users_count
from
	(select user_id from home_page_table
	intersect
	select user_id from user_table) as common_users;

-- UNION ALL of the page tables

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
	
-- Pivot Table
	
drop view if exists page_landings_view;

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
		
-- JOIN for final dataset - as a view - that includes user details and pages visited by them 
	
drop view if exists user_page_journey_view;

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
	
-- Total users by Gender
	
select
	sum(case when sex = 'Female' then 1 end) as number_of_female_users,
	sum(case when sex = 'Male' then 1 end) as number_of_male_users
from
	user_page_journey_view;

-- Total users by Device
	
select
	sum(case when device = 'Desktop' then 1 end) as number_of_desktop_users,
	sum(case when device = 'Mobile' then 1 end) as number_of_mobile_users
from
	user_page_journey_view;

-- Total users by Gender and Device
	
select
	sum(case when sex = 'Female' and device = 'Desktop' then 1 else 0 end) as female_desktop_users,
	sum(case when sex = 'Female' and device = 'Mobile' then 1 else 0 end) as female_mobile_users,
	sum(case when sex = 'Male' and device = 'Desktop' then 1 else 0 end) as male_desktop_users,
	sum(case when sex = 'Male' and device = 'Mobile' then 1 else 0 end) as male_mobile_users
from
	user_page_journey_view;


-- Descriptive Stats - Daily Landings on Home Page by the month

with daily_users as (
	select
		date as signup_date,
		sum(case when home_page_flag = 1 then 1 else 0 end) as users
	from
		user_page_journey_view
	group by
		date
),

details as (
	select
		signup_date,
		users,
		row_number() over (partition by extract(month from signup_date) order by users) as row_number,
		sum(1) over (partition by extract(month from signup_date)) as total
	from
		daily_users
),

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

-- Descriptive Stats - Daily Landings on Search Page by the month

with daily_users as (
	select
		date as signup_date,
		sum(case when search_page_flag = 1 then 1 else 0 end) as users
	from
		user_page_journey_view
	group by
		date
),

details as (
	select
		signup_date,
		users,
		row_number() over (partition by extract(month from signup_date) order by users) as row_number,
		sum(1) over (partition by extract(month from signup_date)) as total
	from
		daily_users
),

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

-- Descriptive Stats - Daily Landings on Payment Page by the month

with daily_users as (
	select
		date as signup_date,
		sum(case when payment_page_flag = 1 then 1 else 0 end) as users
	from
		user_page_journey_view
	group by
		date
),

details as (
	select
		signup_date,
		users,
		row_number() over (partition by extract(month from signup_date) order by users) as row_number,
		sum(1) over (partition by extract(month from signup_date)) as total
	from
		daily_users
),

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

-- Descriptive Stats - Daily Landings on Payment Confirmation Page by the month

with daily_users as (
	select
		date as signup_date,
		sum(case when payment_confirmation_flag = 1 then 1 else 0 end) as users
	from
		user_page_journey_view
	group by
		date
),

details as (
	select
		signup_date,
		users,
		row_number() over (partition by extract(month from signup_date) order by users) as row_number,
		sum(1) over (partition by extract(month from signup_date)) as total
	from
		daily_users
),

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
	
-- All users
	
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
		
-- By Gender
	
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

-- By Device
	
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


-- Conversion rate, per month, week and daily - then break it down by device, gender

-- Monthly Landings and Conversion Rate, all users

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

-- Weekly Landings and Conversion Rate, all users 

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

-- Daily Landings and Conversion Rate, all users

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

-- Monthly Landings and Conversion Rate, by Gender

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
	
-- Weekly Landings and Conversion Rate, by Gender

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
	
-- Daily Landings and conversion Rate, by Gender 

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
	
-- Monthly Landings and Conversion Rate, by Device

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

-- Weekly Landings and Conversion Rate, by Device

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
	
-- Daily Landings and conversion Rate, by Device

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
	
-- Daily Landings and conversion Rate, by Device and Gender

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
-- Checking for the number of records, duplicates or inconsistencies and any missing values in each table

-- Displaying the first 100 records (with all columns) from the home_page_table to get a glimpse of the data

select 
	*
from 
	home_page_table
limit 100;

-- Partial Result:
	
user_id|page     |
-------+---------+
     17|home_page|
     28|home_page|
     37|home_page|
     38|home_page|
     55|home_page|
     72|home_page|
	
-- Calculating the number of records, distinct users, and distinct pages

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	home_page_table;

-- Result:

number_of_records|number_of_users|number_of_pages|
-----------------+---------------+---------------+
            90400|          90400|              1|

-- Counting the number of missing values for user_id and page columns

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	home_page_table
where
	user_id is null or page is null;

-- Result:

missing_user_ids|missing_page|
----------------+------------+
               0|           0|

-- Displaying the first 100 records (with all columns) from the search_page_table to get a glimpse of the data

select 
	*
from 
	search_page_table
limit 100;

-- Partial Result:

user_id|page       |
-------+-----------+
  15866|search_page|
 347058|search_page|
 577020|search_page|
 780347|search_page|
 383739|search_page|

-- Calculating the number of records, distinct users, and distinct pages

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	search_page_table;

-- Result:

number_of_records|number_of_users|number_of_pages|
-----------------+---------------+---------------+
            45200|          45200|              1|

-- Counting the number of missing values for user_id and page columns

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	search_page_table
where
	user_id is null or page is null;

-- Result:

missing_user_ids|missing_page|
----------------+------------+
               0|           0|

-- Displaying the first 100 records (with all columns) from the payment_page_table to get a glimpse of the data

select 
	*
from 
	payment_page_table
limit 100;

-- Partial Result:

user_id|page        |
-------+------------+
 253019|payment_page|
 310478|payment_page|
 304081|payment_page|
 901286|payment_page|
 195052|payment_page|

-- Calculating the number of records, distinct users, and distinct pages

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	payment_page_table;

-- Result:

number_of_records|number_of_users|number_of_pages|
-----------------+---------------+---------------+
             6030|           6030|              1|

-- Counting the number of missing values for user_id and page columns

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	payment_page_table
where
	user_id is null or page is null;

-- Result:

missing_user_ids|missing_page|
----------------+------------+
               0|           0|

-- Displaying the first 100 records (with all columns) from the payment_confirmation_table to get a glimpse of the data

select 
	*
from 
	payment_confirmation_table
limit 100;

-- Partial Result:

user_id|page                     |
-------+-------------------------+
 123100|payment_confirmation_page|
 704999|payment_confirmation_page|
 407188|payment_confirmation_page|
 538348|payment_confirmation_page|
 841681|payment_confirmation_page|

-- Calculating the number of records, distinct users, and distinct pages

select
	count(*) as number_of_records,
	count(distinct user_id) as number_of_users,
	count(distinct page) as number_of_pages
from
	payment_confirmation_table;

-- Result:

number_of_records|number_of_users|number_of_pages|
-----------------+---------------+---------------+
              452|            452|              1|

-- Counting the number of missing values for user_id and page columns

select
	count(user_id) as missing_user_ids,
	count(page) as missing_page
from
	payment_confirmation_table
where
	user_id is null or page is null;

-- Result:

missing_user_ids|missing_page|
----------------+------------+
               0|           0|

-- Displaying the first 100 records (with all columns) from the user_table to get a glimpse of the data

select
	*
from 
	user_table
limit 100;

-- Partial Result:

user_id|date      |device |sex   |
-------+----------+-------+------+
     17|21-04-2015|Desktop|Male  |
     28|29-04-2015|Desktop|Male  |
     37|21-02-2015|Mobile |Male  |
     38|23-03-2015|Mobile |Female|
     55|01-02-2015|Desktop|Male  |
     72|22-04-2015|Desktop|Male  |

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

-- Result:

number_of_records|number_of_users|number_of_dates|starting_date|ending_date|number_of_devices|sex|
-----------------+---------------+---------------+-------------+-----------+-----------------+---+
            90400|          90400|            120|   2015-01-01| 2015-04-30|                2|  2|

-- Counting the values in the device and sex columns

select
	device,
	count(*) as occurrences
from
	user_table
group by
	device
order by
	occurrences desc;

-- Result:

device |occurrences|
-------+-----------+
Desktop|      60200|
Mobile |      30200|

select
	sex,
	count(*) as occurrences
from
	user_table
group by
	sex
order by
	occurrences desc;

-- Result:

sex   |occurrences|
------+-----------+
Male  |      45325|
Female|      45075|

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

-- Result:

missing_user_ids|missing_dates|missing_device|missing_sex|
----------------+-------------+--------------+-----------+
               0|            0|             0|          0|

-- Ensuring that the number of users between the home_page_table and the user_table is consistent

-- Subquery

select 
	count(*) as common_users_count
from
	(select user_id from home_page_table
	intersect
	select user_id from user_table) as common_users;

-- CTE

with common_users as (
	select user_id from home_page_table
		intersect
	select user_id from user_table)
	
select 
	count(*) as common_users_count
from
	common_users;

-- Result:

common_users_count|
------------------+
             90400|

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

-- Partial Result:

user_id|home_page_flag|search_page_flag|payment_page_flag|payment_confirmation_flag|
-------+--------------+----------------+-----------------+-------------------------+
     17|             1|               1|                0|                        0|
     28|             1|               0|                0|                        0|
     37|             1|               1|                0|                        0|
     38|             1|               1|                1|                        0|
     55|             1|               0|                0|                        0|
		
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

-- Partial Result:

user_id|home_page_flag|search_page_flag|payment_page_flag|payment_confirmation_flag|date      |device |sex   |
-------+--------------+----------------+-----------------+-------------------------+----------+-------+------+
     17|             1|               1|                0|                        0|2015-04-21|Desktop|Male  |
     55|             1|               0|                0|                        0|2015-02-01|Desktop|Male  |
     72|             1|               0|                0|                        0|2015-04-22|Desktop|Male  |
    139|             1|               0|                0|                        0|2015-02-05|Desktop|Female|
    158|             1|               0|                0|                        0|2015-04-18|Desktop|Female|
	
-- Calculating the total number of users by gender from the user_page_journey_view
	
select
	sum(case when sex = 'Female' then 1 end) as number_of_female_users,
	sum(case when sex = 'Male' then 1 end) as number_of_male_users
from
	user_page_journey_view;

-- Result:

number_of_female_users|number_of_male_users|
----------------------+--------------------+
                 45075|               45325|

-- Calculating the total number of users by device type from the user_page_journey_view
	
select
	sum(case when device = 'Desktop' then 1 end) as number_of_desktop_users,
	sum(case when device = 'Mobile' then 1 end) as number_of_mobile_users
from
	user_page_journey_view;

-- Result:

number_of_desktop_users|number_of_mobile_users|
-----------------------+----------------------+
                  60200|                 30200|

-- Calculating the total number of users by gender and device type from the user_page_journey_view
	
select
	sum(case when sex = 'Female' and device = 'Desktop' then 1 else 0 end) as female_desktop_users,
	sum(case when sex = 'Female' and device = 'Mobile' then 1 else 0 end) as female_mobile_users,
	sum(case when sex = 'Male' and device = 'Desktop' then 1 else 0 end) as male_desktop_users,
	sum(case when sex = 'Male' and device = 'Mobile' then 1 else 0 end) as male_mobile_users
from
	user_page_journey_view;

-- Result:

female_desktop_users|female_mobile_users|male_desktop_users|male_mobile_users|
--------------------+-------------------+------------------+-----------------+
               29997|              15078|             30203|            15122|

-- Counting the number of user signups on each engagement/activity date

select
	date as engagement_date,
	count(user_id) as signed_up_users_count
from
	user_page_journey_view
group by
	date;

-- Partial Result:

engagement_date|signed_up_users_count|
---------------+---------------------+
     2015-01-01|                  712|
     2015-01-02|                  721|
     2015-01-03|                  760|
     2015-01-04|                  713|
     2015-01-05|                  754|
     2015-01-06|                  742|

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

-- Result:

engagement_month|signed_up_users_count|avg_signups|min_signups|max_signups|
----------------+---------------------+-----------+-----------+-----------+
January         |                22600|        729|        668|        788|
February        |                22600|        807|        759|        877|
March           |                22600|        729|        684|        777|
April           |                22600|        753|        699|        806|

	
-- Conversion Rates
	
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
	)
	
select 
	funnel_stage,
	funnel_stage_name,
	conversion_rate
from 
	conversion_rates_cte
order by
	funnel_stage;

-- Result:

funnel_stage|funnel_stage_name                 |conversion_rate|
------------+----------------------------------+---------------+
           1|home -> search                    |          50.00|
           2|search -> payment                 |          13.34|
           3|payment -> confirmation of payment|           7.50|
		
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
)

select
	sex,
	funnel_stage,
	funnel_stage_name,
	conversion_rate
from 
	gender_conversion_rates_cte
order by
	funnel_stage;

-- Result:

sex   |funnel_stage|funnel_stage_name                 |conversion_rate|
------+------------+----------------------------------+---------------+
Female|           1|home -> search                    |          50.31|
Male  |           1|home -> search                    |          49.69|
Female|           2|search -> payment                 |          13.67|
Male  |           2|search -> payment                 |          13.01|
Female|           3|payment -> confirmation of payment|           7.77|
Male  |           3|payment -> confirmation of payment|           7.20|

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
)
select
	device,
	funnel_stage,
	funnel_stage_name,
	conversion_rate
from
	device_conversion_rates_cte
order by
	funnel_stage;

-- Result:

device |funnel_stage|funnel_stage_name                 |conversion_rate|
-------+------------+----------------------------------+---------------+
Desktop|           1|home -> search                    |          50.00|
Mobile |           1|home -> search                    |          50.00|
Desktop|           2|search -> payment                 |          10.00|
Mobile |           2|search -> payment                 |          20.00|
Desktop|           3|payment -> confirmation of payment|           4.98|
Mobile |           3|payment -> confirmation of payment|          10.00|

-- Calculating monthly user landings on different pages and their corresponding conversion rates

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

-- Result:

signup_month|conversion_rate_one|conversion_rate_two|conversion_rate_three|
------------+-------------------+-------------------+---------------------+
January     |              59.97|              17.63|                 7.91|
February    |              60.56|              17.62|                 7.17|
March       |              39.29|               7.11|                 6.97|
April       |              40.18|               6.57|                 7.71|

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

-- Partial Result:

signup_week|conversion_rate_one|conversion_rate_two|conversion_rate_three|
-----------+-------------------+-------------------+---------------------+
        1.0|              60.29|              17.12|                 8.33|
        2.0|              59.39|              16.75|                 9.29|
        3.0|              60.55|              17.15|                 6.69|
        4.0|              59.15|              19.30|                 8.22|
        5.0|              61.08|              17.65|                 7.17|
        6.0|              60.28|              17.30|                 7.64|
        7.0|              60.27|              17.65|                 6.59|
        8.0|              60.66|              18.13|                 6.97|
        9.0|              57.95|              16.40|                 7.21|

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

-- Partial Result:

signup_date|conversion_rate_one|conversion_rate_two|conversion_rate_three|
-----------+-------------------+-------------------+---------------------+
 2015-01-01|              61.24|              17.43|                 7.89|
 2015-01-02|              62.00|              18.79|                 5.95|
 2015-01-03|              55.53|              15.17|                10.94|
 2015-01-04|              62.69|              17.00|                 9.21|
 2015-01-05|              61.27|              19.05|                12.50|
 2015-01-06|              59.97|              15.06|                13.43|
 2015-01-07|              58.21|              13.61|                 7.27|
 2015-01-08|              57.28|              15.65|                 7.81|

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
	)
	
select
	to_char(to_date(signup_month::text, 'MM'), 'Month') as signup_month,
	sex,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	gender_monthly_landings_cte
order by
	signup_month, sex;

-- Result:

signup_month|sex   |conversion_rate_one|conversion_rate_two|conversion_rate_three|
------------+------+-------------------+-------------------+---------------------+
January     |Female|              60.57|              17.98|                 8.77|
January     |Male  |              59.37|              17.27|                 6.97|
February    |Female|              60.90|              18.11|                 6.96|
February    |Male  |              60.23|              17.14|                 7.39|
March       |Female|              39.59|               7.57|                 7.72|
March       |Male  |              38.99|               6.64|                 6.12|
April       |Female|              40.04|               6.35|                 7.02|
April       |Male  |              40.31|               6.80|                 8.33|

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
	)
	
select
	signup_week,
	sex,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	gender_weekly_landings_cte
order by
	signup_week, sex;

-- Partial Result:

signup_week|sex   |conversion_rate_one|conversion_rate_two|conversion_rate_three|
-----------+------+-------------------+-------------------+---------------------+
        1.0|Female|              60.75|              17.35|                 6.58|
        1.0|Male  |              59.84|              16.89|                10.14|
        2.0|Female|              60.35|              16.67|                11.67|
        2.0|Male  |              58.41|              16.84|                 6.83|
        3.0|Female|              61.15|              17.02|                 8.99|
        3.0|Male  |              59.94|              17.29|                 4.30|
        4.0|Female|              59.11|              19.58|                 8.17|

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
	)
	
select
	signup_date,
	sex,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	gender_daily_landings_cte
order by
	signup_date, sex;

-- Partial Result:

signup_date|sex   |conversion_rate_one|conversion_rate_two|conversion_rate_three|
-----------+------+-------------------+-------------------+---------------------+
 2015-01-01|Female|              62.68|              20.45|                 6.67|
 2015-01-01|Male  |              59.83|              14.35|                 9.68|
 2015-01-02|Female|              64.51|              17.90|                 4.88|
 2015-01-02|Male  |              59.56|              19.72|                 6.98|
 2015-01-03|Female|              53.33|              13.00|                11.54|
 2015-01-03|Male  |              57.66|              17.12|                10.53|
 2015-01-04|Female|              62.88|              17.62|                 5.00|
 2015-01-04|Male  |              62.50|              16.36|                13.89|
	
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
	)
	
select
	to_char(to_date(signup_month::text, 'MM'), 'Month') as signup_month,
	device,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	device_monthly_landings_cte
order by
	signup_month, device;

-- Result:

signup_month|device |conversion_rate_one|conversion_rate_two|conversion_rate_three|
------------+-------+-------------------+-------------------+---------------------+
January     |Desktop|              50.03|              16.22|                 4.91|
January     |Mobile |              79.80|              19.40|                11.04|
February    |Desktop|              50.71|              15.61|                 4.53|
February    |Mobile |              80.20|              20.17|                 9.75|
March       |Desktop|              48.97|               4.02|                 4.73|
March       |Mobile |              19.99|              22.20|                 8.96|
April       |Desktop|              50.29|               3.99|                 7.28|
April       |Mobile |              20.01|              19.52|                 8.14|

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
	)
	
select
	signup_week,
	device,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	device_weekly_landings_cte
order by
	signup_week, device;

-- Partial Result:

signup_week|device |conversion_rate_one|conversion_rate_two|conversion_rate_three|
-----------+-------+-------------------+-------------------+---------------------+
        1.0|Desktop|              50.46|              15.28|                 3.97|
        1.0|Mobile |              80.59|              19.50|                12.75|
        2.0|Desktop|              49.85|              14.49|                 5.74|
        2.0|Mobile |              78.23|              19.60|                12.60|
        3.0|Desktop|              50.68|              16.28|                 4.01|
        3.0|Mobile |              79.66|              18.22|                 9.64|
        4.0|Desktop|              48.99|              18.36|                 6.07|
        4.0|Mobile |              79.44|              20.46|                10.60|
	
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
	)
	
select
	signup_date,
	device,
	round((1.0 * search_page_users / home_page_users) * 100, 2) as conversion_rate_one,
	round((1.0 * payment_page_users / search_page_users) * 100, 2) as conversion_rate_two,
	round((1.0 * payment_confirmation_users / payment_page_users) * 100, 2) as conversion_rate_three
from
	device_daily_landings_cte
order by
	signup_date, device;

-- Partial Result:

signup_date|device |conversion_rate_one|conversion_rate_two|conversion_rate_three|
-----------+-------+-------------------+-------------------+---------------------+
 2015-01-01|Desktop|              51.93|              18.36|                 2.13|
 2015-01-01|Mobile |              82.19|              16.11|                17.24|
 2015-01-02|Desktop|              53.93|              16.86|                 2.27|
 2015-01-02|Mobile |              78.48|              21.51|                10.00|
 2015-01-03|Desktop|              43.79|               9.91|                13.64|
 2015-01-03|Mobile |              79.05|              21.00|                 9.52|
 2015-01-04|Desktop|              52.53|              15.26|                 2.63|
 2015-01-04|Mobile |              82.85|              19.19|                15.79|
	
-- Calculating daily user landings on different pages and their corresponding conversion rates, by gender/sex and device type

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
	)
	
select
	signup_date,
	device,
	sex,
	coalesce(round(1.0 * search_page_users / nullif(home_page_users, 0) * 100, 2), 0) as conversion_rate_one,
	coalesce(round(1.0 * payment_page_users / nullif(search_page_users, 0) * 100, 2), 0) as conversion_rate_two,
	coalesce(round(1.0 * payment_confirmation_users / nullif(payment_page_users, 0) * 100, 2), 0) as conversion_rate_three
from
	device_gender_daily_landings_cte
order by 
	signup_date, device, sex;

-- Partial Result:

signup_date|device |sex   |conversion_rate_one|conversion_rate_two|conversion_rate_three|
-----------+-------+------+-------------------+-------------------+---------------------+
 2015-01-01|Desktop|Female|              52.84|              19.83|                 0.00|
 2015-01-01|Desktop|Male  |              51.14|              17.04|                 4.35|
 2015-01-01|Mobile |Female|              81.15|              21.21|                14.29|
 2015-01-01|Mobile |Male  |              83.51|               9.88|                25.00|
 2015-01-02|Desktop|Female|              57.63|              14.71|                 5.00|
 2015-01-02|Desktop|Male  |              50.40|              19.20|                 0.00|
 2015-01-02|Mobile |Female|              78.15|              22.58|                 4.76|

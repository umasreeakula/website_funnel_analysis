# Website Funnel Analysis

This dataset, available at [Kaggle](https://www.kaggle.com/datasets/aerodinamicc/ecommerce-website-funnel-analysis), contains user behaviour data from an e-commerce website with four pages: home, search, payment, and payment confirmation, tracking user interactions and conversion funnel progression.

There are five tables: a table for each page with the user ID and a flag indicating the user visited the page. The fifth table contains additional user information, including the device type used for accessing the website, the date of activity, and gender.

I analysed the dataset using DBeaver, connected to a PostgreSQL database system.

## Business Problem and Scenario

The e-commerce company aims to increase revenue by optimising the conversion rate across its website's funnel. By identifying and addressing the bottlenecks to conversion, the company seeks to enhance the user experience and drive higher sales volume, particularly among new users.

### Questions:
1. What are the conversion rates for each funnel stage, and how do they vary across the different stages? (Home -> Search, Search -> Payment, Payment -> Payment Confirmation)
2. Are there any significant drops or spikes in conversion rates at particular funnel stages?
3. How do conversion rates differ based on user attributes such as device type (desktop, mobile) and sex (male, female)?
4. How do conversion rates vary (daily, weekly, monthly)?

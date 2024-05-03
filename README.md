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
-> A comprehensive website audit will help analyse the website's performance metrics to understand the issues encountered. Investigate events around March 1st. 
- Have there been any updates or changes to how users access the website via mobile? 
- Did these mobile-specific changes create friction or confusion for website users?
- Did these affect the page load time or server response time? How about overall website speed?
  
-> Watch session recordings, if possible, to understand how users failed to interact or progress around March 1st. Compare it with those who've progressed and interacted to understand differences in user journeys.
- Review elements used to navigate from one page to another. Are the page elements confusing/distracting? Is any unusual behaviour indicating broken page elements? Are the CTAs (call-to-action) clear?
  
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

 #### Notes:
 In this project, users and sessions are used interchangeably, despite their differing definitions in the real world. The assumption is that each user ID represents a user accessing the website only once, resulting in only one session per user.

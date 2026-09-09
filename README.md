Customer Shopping Behavior Analysis

End-to-end data analytics workflow. Python (cleaning) to PostgreSQL (analysis) to Power BI (visualization).


Project Overview

This project analyzes 3,900 customer transactions from a retail dataset to answer a set of business questions: who's buying, what they're buying, which segments and products perform best, and, the key question, whether discounts, promo codes, and the subscription program are actually increasing how much customers spend.

This was a personal practice project to apply the full analytics pipeline end to end: cleaning messy raw data, writing real SQL business questions, and building a dashboard, then packaging the results the way I would for a non-technical audience.

Tools Used
Stage	Tool
Data cleaning & EDA	Python (pandas, matplotlib, seaborn), Jupyter Notebook
Analysis (business questions)	PostgreSQL (17 SQL queries)
Visualization	Power BI (4-page dashboard)
Reporting	Markdown (this file) + PDF stakeholder report
Repository Contents

File	Description
original_unclean_customer_shopping_behavior.csv	Raw data export, as received
Python_Customer_shopping_behavior_analysis.ipynb	Data cleaning & exploratory analysis notebook
cleaned_shopping_data.csv	Cleaned dataset (output of the notebook, input to SQL)
Postgres_customer_shopping_finished_version.sql	17 SQL business questions run against the cleaned data in PostgreSQL
PoweBi_visual_customer_shopping_behavior.pdf	Export of the 4-page Power BI dashboard
Customer_Shopping_Behavior_Stakeholder_Report.pdf	Polished, non-technical findings report written for a business audience
Data Cleaning Summary

Handled in the Python notebook before loading into PostgreSQL:

Standardized column names (spacing, casing) to snake_case for SQL compatibility.
Checked for duplicates. None found (customer_id and full-row checks).
Investigated 37 missing review_rating values (~1% of rows). Rather than dropping or imputing blindly, I checked whether the nulls followed a pattern. They did. All 37 belonged to male customers who had both a discount and a promo code applied, suggesting a gap earlier in the customer journey rather than random missing data. This is called out explicitly rather than silently filled.
Converted Yes/No fields (subscription_status, discount_applied, promo_code_used) to boolean for reliable aggregation.
Binned age into five customer age groups (18-25, 26-35, 36-50, 51-65, 65+).
Checked for outliers in age and purchase amount via boxplots. None found, distributions look reasonable.

Known limitation: the dataset has no transaction date/timestamp field, so this analysis describes overall patterns in the extract rather than trends over time (e.g. month-over-month or seasonal growth).

Business Questions Answered (SQL)

The full query set is in Postgres_customer_shopping_finished_version.sql. Highlights:

Sales by age group and gender
Top 10 best-selling items and top-performing category by % of total sales
Top 5 best-selling locations
Best-selling size and color per category
Best-selling season per category
Average review rating by category
Most common shipping type, overall and by category/age group
Best-spending age group by total dollars (not just order count)
Most-used payment method, overall and by category
Whether discounts, promo codes, and subscriptions correlate with higher spend
Key Findings
Clothing drives the business: 45% of revenue ($104,264), nearly double the next category (Accessories, $74,200).
Customers aged 36+ generate the majority of revenue, led by the 51-65 group ($67,576).
Discounts and promo codes show no lift in average order value. $59.28 (with) vs. $60.13 (without).
The subscription program shows no measurable lift in order value either ($59.49 vs. $59.87), though subscribers have slightly more historical purchases on record.
Sales are fairly evenly distributed across locations, seasons, and shipping methods, no major outliers.

See the full report for the complete write-up, charts, and recommendations.

Dashboard

The Power BI dashboard (PoweBi_visual_customer_shopping_behavior.pdf) covers:

Sales Overview: total revenue, revenue by category/gender/season, top locations
Customer Insights: revenue by age group, promo code usage, purchase frequency by gender
Product Overview: top-selling items, review ratings by category, top colors and sizes
Payments & Logistics: payment method and shipping type breakdowns
What I'd Do Differently Next Time
Request a dataset that includes transaction dates to support trend analysis.
Set up a proper A/B test structure for discount effectiveness instead of relying on observational data.
Add a data dictionary at the start of the project to document field definitions before analysis.

This is a practice/portfolio project using a public-style retail dataset. It is not affiliated with any real company.

SELECT * FROM customer_shopping_behavior LIMIT 10;

--sales by age group[
SELECT 
  age_group,
  count(*) AS total_sales
FROM customer_shopping_behavior
GROUP BY age_group
ORDER BY total_sales;


--2 sales by gender
SELECT 
  gender,
  COUNT (*) as total_sales
FROM customer_shopping_behavior
GROUP BY gender
ORDER BY total_sales DESC;

--3 TOP 10 items purchased 
SELECT 
  item_purchased,
  COUNT(*) AS total_sales
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY total_sales DESC
LIMIT 10;

--4 CATEGORIES BY SALES - WHICH IS THE BEST SELLING CATEGORY AND % OF SALES
WITH category_counts AS (
    SELECT 
	   category,
	   count(*) AS total_sales
	FROM customer_shopping_behavior
	GROUP BY category
   )
   SELECT
    category,
	total_sales,
	ROUND(100.0*total_sales/SUM(total_sales)OVER(),2)
	
   FROM category_counts 
   ORDER BY total_sales DESC;


   --5TOP 5 BEST SELLING LOCATIONS
      SELECT
     location,
	 count(*) AS total_sales
   FROM customer_shopping_behavior
   GROUP BY location
   ORDER BY total_sales DESC
   LIMIT 5;
--6

   --7. Breakdown of sales per category per number of sales without ranking to find the best in each size 
   --and category
   WITH size_counts AS(
      SELECT category,
	         size,
			 count(*) AS total_sales
	  FROM customer_shopping_behavior
	  GROUP BY category,size
   )
   SELECT
     *
   FROM size_counts
   ORDER BY category,total_sales DESC;

   --8 knowing the best - number one selling size across different category
   -- turns out its size Medium
   --if i use rn 2- Runners up, its size large
     WITH size_counts AS (
     SELECT category,
	        size,
			COUNT(*) as total_sales
	 FROM customer_shopping_behavior
	 GROUP BY category,size
 ),
     ranked AS (
       SELECT category,
	          size,
			  total_sales,
			  ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_sales DESC ) AS rn
	   FROM size_counts
	 )
  SELECT category,
         size,
		 total_sales
  FROM ranked
  WHERE rn = 1
  ORDER BY total_sales DESC;

--9 Runners up
  WITH size_counts AS (
     SELECT category,
	        size,
			COUNT(*) as total_sales
	 FROM customer_shopping_behavior
	 GROUP BY category,size
 ),
     ranked AS (
       SELECT category,
	          size,
			  total_sales,
			  ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_sales DESC ) AS rn
	   FROM size_counts
	 )
  SELECT category,
         size,
		 total_sales
  FROM ranked
  WHERE rn = 2
  ORDER BY total_sales DESC;

  --9 Best selling color per category
  --three variables category,color, count of total sales
 --first cte counts total sales per category + color combination
 --second cte takes the first breakdown and and ranks colors within each category from highest to lowst using ROW_NUMBER() by adding a new column rn
 WITH color_count AS (
        SELECT  category,
	        color,
			COUNT(*) AS total_sales
	    FROM customer_shopping_behavior
	    GROUP BY category,color
  ), ranked AS(
        SELECT category,
		       color,
			   total_sales,
			   ROW_NUMBER() OVER(PARTITION BY category ORDER By total_sales ) AS rn 
		FROM color_count
  ) 
  SELECT category,
         color,
		 total_sales
  FROM ranked
  WHERE rn = 1
  ORDER BY total_sales DESC;

  --10 best selling season per category
  WITH season_counts AS (
        SELECT category,
		       season,
			   COUNT(*) AS total_sales
		FROM customer_shopping_behavior
		GROUP BY category, season
  ), ranking AS(
        SELECT
           category,
		   season,
		   total_sales,
		   ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_sales) AS rn
		FROM season_counts
		
  )SELECT category,
          season,
		  total_sales
   FROM ranking
   WHERE rn =1
   ORDER BY total_sales DESC;

--11. Best average review rating by category
   --three category,review rating(do an average for each category),count of sales

 SELECT category,
        ROUND(AVG(review_rating)::numeric,2) AS avg_review_rating,
		COUNT(*) AS total_sales
 FROM customer_shopping_behavior
 GROUP BY category
 ORDER BY avg_review_rating DESC;

--12 What is the most common shipping type
---most to the least used
SELECT shipping_type,
       COUNT(*) AS total_sales

FROM customer_shopping_behavior
GROUP BY shipping_type
ORDER BY total_sales DESC;

--13 Best shipping type in each category
--will use CTES
WITH shipping_count AS(
       SELECT category,
              shipping_type,
	          count(*) AS total_sales
       FROM customer_shopping_behavior 
       GROUP BY category,shipping_type
  
  ),ranking AS(
        SELECT category,
		       shipping_type,
			   total_sales,
			   ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_sales DESC) AS rn

		FROM shipping_count	  
  )
  SELECT category,
		 shipping_type,
		 total_sales
  FROM ranking
  WHERE rn = 1
  ORDER BY total_sales DESC;

  --14 Best buying age groups by total dollars spent(not like in question 1 where its by number of sales)
   SELECT age_group,
          SUM(purchase_amount_usd) AS total_spent,
		  COUNT(*) as total_sales
   FROM customer_shopping_behavior
   GROUP BY age_group
   ORDER BY total_spent DESC;

   --15 Most used shipping type per age group
   WITH shipping_counts AS(
       SELECT age_group,
	          shipping_type,
			  COUNT(*) AS total_sales
	   FROM customer_shopping_behavior
	   GROUP BY age_group,shipping_type
   ), ranking AS(
       SELECT age_group,
	          shipping_type,
			  total_sales,
			  ROW_NUMBER()OVER(PARTITION BY age_group ORDER BY total_sales DESC) AS rn
	    FROM shipping_counts	  
   ) 
   SELECT age_group,
          shipping_type,
		  total_sales
   FROM ranking
   WHERE rn = 1
   ORDER BY total_sales DESC;

   --16 Looking the the payment methods in general - MOST USED
  SELECT payment_method,
         COUNT(*) AS total_sales
  FROM customer_shopping_behavior
  GROUP BY payment_method
  ORDER BY total_sales DESC;

-- 17 payment metthod preference  by category
   WITH payment_counts AS (
    SELECT
        category,
        payment_method,
        COUNT(*) AS total_sales
    FROM customer_shopping_behavior
    GROUP BY category, payment_method
),
ranked AS (
    SELECT
        category,
        payment_method,
        total_sales,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rn
    FROM payment_counts
)
SELECT category, payment_method, total_sales, rn
FROM ranked
ORDER BY category, rn;

-- to find the number one choice in each category 
WITH payment_counts AS (
    SELECT
        category,
        payment_method,
        COUNT(*) AS total_sales
    FROM customer_shopping_behavior
    GROUP BY category, payment_method
),
ranked AS (
    SELECT
        category,
        payment_method,
        total_sales,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rn
    FROM payment_counts
)
SELECT category, payment_method, total_sales
FROM ranked
WHERE rn = 1
ORDER BY category
;



   
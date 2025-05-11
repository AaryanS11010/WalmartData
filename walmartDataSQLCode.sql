CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    qunatity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULl,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1) 
    
);

-- ----------------------------------------------------------------------
-- ----------------------Feature Engineering-----------------------------
-- time_of_day
SELECT
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
    ) AS time_of_date
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales 
SET time_of_day = (
	CASE
			WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
			WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
			ELSE "Evening"
		END
);


-- day_name
SELECT
	date,
    DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name
SELECT
	date,
    MONTHNAME(date) as month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);

UPDATE sales
SET month_name = MONTHNAME(date);

-- ----------------------------------------------------------------------



-- ----------------------------------------------------------------------
-- ---------------------- Generic ---------------------------------------


-- Number of unique cities
SELECT
	DISTINCT city
FROM sales;

SELECT
	DISTINCT branch
FROM sales;


-- Which city is in each branch
SELECT
	DISTINCT city,
    branch
FROM sales;

-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- ---------------------- Product ---------------------------------------

-- Number of unique product lines
SELECT
 DISTINCT product_line
FROM sales;

-- Most common payment method
SELECT
payment_method,
	COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;


-- Most selling product line
SELECT
product_line,
	COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;


-- Total revenue by month
SELECT
	month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;


-- Month with largest COGS
SELECT
	month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs;

-- Product line with largest revenue
SELECT
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- City with largest revenue
SELECT
	branch,
	city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city,branch
ORDER BY total_revenue DESC;



-- Product line with largest VAT
SELECT
	product_line,
    AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


-- Branches that sold more products that average product sold
SELECT
	branch,
    SUM(qunatity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(qunatity) > (SELECT AVG(qunatity) FROM sales);

-- Most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- Average rating of each product line
SELECT
	product_line,
    ROUND(AVG(rating), 4) AS avg_rating, 
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;



-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- ------------------------ Sales ---------------------------------------


-- Number of sales made in each time of day per weekday
SELECT
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which customer types bring in most revenue
SELECT
	customer_type,
    SUM(total) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- Which city has the largest VAT
SELECT
	city,
    AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer types pays the msot in VAT
SELECT
	customer_type,
    AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;




-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- ------------------------ Customer ------------------------------------
-- Which customer types pays the most in VAT
SELECT
	customer_type,
    COUNT(customer_type) AS cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC;



-- Number of unique payment methods
SELECT
	payment_method,
    COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- Which customer type buys the most
SELECT
	customer_type,
    COUNT(*) AS cst_cnt
FROM sales
GROUP BY customer_type
ORDER BY cst_cnt DESC;


-- What is the gender of most of the customers
SELECT
	gender,
    COUNT(gender) AS gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Gender distribution of each branch
SELECT
	gender,
    COUNT(gender) AS gender_cnt
FROM sales
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt DESC;


-- What time of the day do customers give most ratings
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- What time of the day do customers give more ratings per branch
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "B"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY avg_rating DESC;

-- ----------------------------------------------------------------------


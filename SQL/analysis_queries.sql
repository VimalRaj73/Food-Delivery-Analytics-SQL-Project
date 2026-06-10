-- Food Delivery Analytical Queries

Use food_delivery_db;

-- 1) How many total orders were placed?

SELECT COUNT(order_id) as total_orders
FROM orders;

-- 2) How many customers have registered in the platform?

SELECT COUNT(c.customer_id) AS total_customers
FROM customers c;

-- 3) How many restaurants are available on the platform?

SELECT COUNT(r.restaurant_id) AS total_restaurants
FROM restaurants r; 

-- 4) What is the total revenue generated from all orders?

SELECT  SUM(o.order_amount) AS total_revenue
FROM orders o;

-- 5) What is the average order value?

SELECT AVG(o.order_amount) AS average_order_value
FROM orders o; 

-- 6) How many orders were successfully completed and cancelled?

SELECT o.order_status,COUNT(o.order_id)
FROM Orders o
GROUP BY order_status;

-- 7) Which payment method is used the most?

SELECT p.payment_method, COUNT(p.payment_id) AS usage_count
FROM payments p
GROUP BY payment_method
ORDER BY usage_count DESC;

-- 8) How many successful and failed payments were recorded?

SELECT p.payment_status, COUNT(p.payment_id) AS recorded_payments
FROM payments p
GROUP BY payment_status;

-- 9) Which cities have the highest number of customers?

SELECT c.city,COUNT(c.customer_id) AS customer_count
FROM customers c
GROUP BY c.city
ORDER BY customer_count DESC;

-- 10) Which cuisine types are available on platform?

 SELECT DISTINCT cuisine FROM restaurants;

-- 11) Which restaurants received the highest number of orders?

SELECT r.restaurant_name,COUNT(o.order_id) AS total_orders
FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_orders DESC;

-- 12) Which restaurants generated the highest revenue?

SELECT r.restaurant_name, SUM(o.order_amount) AS total_revenue
FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_revenue DESC;

-- 13) Which customer city placed the most orders?

SELECT c.city, COUNT(o.order_id) AS total_orders
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_orders DESC;

-- 14) Which customer city generated the highest revenue?

SELECT c.city, SUM(o.order_amount) AS total_revenue
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;

-- 15) Which cuisine type received the most orders?

SELECT r.cuisine, COUNT(o.order_id) AS total_orders
FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.cuisine
ORDER BY total_orders DESC;

-- 16) Which cuisine type generated the most revenue?

SELECT r.cuisine, SUM(o.order_amount) AS revenue
FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.cuisine
ORDER BY revenue DESC;

-- 17) Which customers spent the most money?

SELECT c.customer_name, SUM(o.order_amount) AS total_spent
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 18) Which customers placed the highest number of orders?

SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;

-- 19) What is the average delivery time across all orders?

SELECT AVG(delivery_time) AS average_delivery_time 
FROM delivery; 

-- 20) Which restaurants have the fastest average delivery time?

SELECT r.restaurant_name, AVG(d.delivery_time) AS average_delivery_time
FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id 
JOIN delivery d ON o.order_id = d.order_id
GROUP BY r.restaurant_name
ORDER BY average_delivery_time ASC;

-- 21) Which restaurants have the slowest average delivery time?

SELECT r.restaurant_name, AVG(d.delivery_time) AS average_delivery_time
FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id 
JOIN delivery d ON o.order_id = d.order_id
GROUP BY r.restaurant_name
ORDER BY average_delivery_time DESC;

-- 22) Which day of the week receives the highest number of orders?

SELECT DAYNAME(order_date) AS day_name, COUNT(order_id) as total_orders FROM orders
GROUP BY day_name
ORDER BY total_orders DESC; 

-- 23) Which day of the week generates the highest revenue?

SELECT DAYNAME(order_date) AS day_name, SUM(order_amount) as revenue
FROM orders
GROUP BY day_name
ORDER BY revenue DESC; 

-- 24) What is the monthly revenue trend?

SELECT MONTHNAME(order_date) AS month_name, SUM(order_amount) as revenue
FROM orders
GROUP BY month_name
ORDER BY month_name;

-- 25) What is the monthly order trend?

SELECT MONTHNAME(order_date) AS month_name, COUNT(order_id) as total_orders
FROM orders
GROUP BY month_name
ORDER BY month_name;

-- 26) Identify repeat customers

SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING total_orders > 1
ORDER BY total_orders DESC;

-- 27) Rank customers based on total revenue

SELECT restaurant_name,revenue,RANK() OVER(ORDER BY revenue DESC) AS restaurant_rank
FROM (SELECT r.restaurant_name,SUM(o.order_amount) AS revenue 
FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name) AS restaurant_revenue;

-- 28) Rank customers based on total spending

SELECT customer_name,total_spend,RANK() OVER(ORDER BY total_spend DESC) AS customer_rank
FROM (SELECT c.customer_name,SUM(o.order_amount) AS total_spend
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name) AS total_customers;

-- 29) Find the top 3 customers by spending

SELECT c.customer_name, SUM(o.order_amount) AS total_spending
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spending DESC
LIMIT 3;

-- 30) Find the top 3 restaurants by revenue

SELECT r.restaurant_name, SUM(order_amount) AS revenue
FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY revenue DESC
LIMIT 3; 

-- 31) Find restaurants whose revenue is above the average restaurant revenue

WITH restaurant_revenue AS
(SELECT r.restaurant_id, r.restaurant_name, SUM(o.order_amount) AS revenue
FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name)
SELECT restaurant_name, revenue FROM restaurant_revenue
WHERE revenue > (SELECT AVG(revenue) FROM restaurant_revenue); 

-- 32) Find the top customer in each city based on spending

WITH customer_spending AS
(SELECT c.city, c.customer_name, SUM(order_amount) AS spending
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city, c.customer_name )
SELECT city, customer_name, spending
FROM (SELECT city, customer_name, spending, 
ROW_NUMBER() OVER (PARTITION BY city
ORDER BY spending DESC) AS rn
FROM customer_spending) t
WHERE rn = 1;

 
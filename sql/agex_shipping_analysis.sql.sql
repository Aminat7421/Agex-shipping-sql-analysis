AgeX Shipping SQL Analysis — SQL Script

-- Q1: Total number of customers
SELECT COUNT(customer_id) AS total_customers
FROM customers;


-- Q2: Customers who have shipped (unique customers with orders)
SELECT COUNT(DISTINCT customer_id) AS customers_with_orders
FROM shipping_orders;


-- Q3: Registered customers who have NOT placed any order
SELECT c.first_name, c.last_name
FROM customers AS c
LEFT JOIN shipping_orders AS s ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;


-- Q4: Total employee discounts given
SELECT SUM(discounts_applied) AS total_employee_discounts
FROM shipping_orders AS s
INNER JOIN customers AS c ON c.customer_id = s.customer_id
WHERE c.is_employee = 1;


-- Q5: Number of customers in each country
SELECT country, COUNT(*) AS total_customers
FROM customers
GROUP BY country;


-- Q6: Total sales by origin country
SELECT origin_country, SUM(final_cost) AS total_sales
FROM shipping_orders
GROUP BY origin_country;


-- Q7: Total sales by destination country
SELECT destination_country, SUM(final_cost) AS sales_by_destination
FROM shipping_orders
GROUP BY destination_country;


-- Q8: Total annual sales (sales per year)
SELECT YEAR(order_date) AS year, SUM(final_cost) AS total_sales
FROM shipping_orders
GROUP BY YEAR(order_date);


-- Q9: Average shipping cost per pound (by origin country)
SELECT origin_country, AVG(final_cost / weight_lbs) AS avg_cost_per_lb
FROM shipping_orders
GROUP BY origin_country;


-- Q10: Most expensive order
SELECT package_id, final_cost
FROM shipping_orders
WHERE final_cost IS NOT NULL
ORDER BY final_cost DESC
LIMIT 1;


-- Q11: High-value customers (customers who spent more than $500)
SELECT customer_id, SUM(final_cost) AS total_spent
FROM shipping_orders
GROUP BY customer_id
HAVING SUM(final_cost) > 500
ORDER BY total_spent DESC;


-- Q12: Total revenue for shipments from Nigeria to Canada
SELECT SUM(final_cost) AS total_revenue
FROM shipping_orders
WHERE origin_country = 'Nigeria'
AND destination_country = 'Canada';


-- Q13: Employee shipments above 30 lbs
SELECT SUM(s.final_cost) AS total_employee_sales
FROM shipping_orders AS s
INNER JOIN customers AS c ON c.customer_id = s.customer_id
WHERE c.is_employee = 1
AND s.weight_lbs > 30;


-- Q14: Top 3 most popular shipping routes
SELECT origin_country, destination_country, COUNT(*) AS package_count
FROM shipping_orders
GROUP BY origin_country, destination_country
ORDER BY package_count DESC
LIMIT 3;


-- Q15: Customers whose last name starts with 'O'
SELECT first_name, last_name
FROM customers
WHERE last_name LIKE 'O%';


-- Q16: Package tracking string
SELECT CONCAT('Package ', package_id, ' from ', origin_country, ' to ', destination_country)
AS tracking_info
FROM shipping_orders;


-- Q17: Top 5 spenders in the USA
SELECT CONCAT(c.first_name, ' ', c.last_name, ' (', c.country, ')') AS full_name,
       SUM(s.final_cost) AS total_spent
FROM customers AS c
JOIN shipping_orders AS s ON c.customer_id = s.customer_id
WHERE c.country = 'USA'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;

SELECT customer_state, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 5;


-- 2. 
SELECT t.product_category_name_english AS category,
       COUNT(DISTINCT p.product_id) AS unique_products
FROM products p
JOIN product_category_name_translation t
  ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY unique_products DESC;



-- 3. 
SELECT strftime('%Y-%m', order_purchase_timestamp) AS month,
       COUNT(order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;



-- 4. 
SELECT op.payment_type,
       ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM order_items oi
JOIN order_payments op ON oi.order_id = op.order_id
GROUP BY op.payment_type
ORDER BY total_revenue DESC;

-- 5. Repeat Customers (Customers who ordered more than once)
SELECT 
    c.customer_unique_id,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY order_count DESC;

-- 6. Average Delivery Time (in Days)
SELECT 
    ROUND(AVG(
        JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp)
    ), 2) AS avg_delivery_days
FROM orders
WHERE 
    order_delivered_customer_date IS NOT NULL 
    AND order_purchase_timestamp IS NOT NULL;


-- 7. Top 5 Products by Revenue
SELECT 
    oi.product_id,
    p.product_category_name,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY oi.product_id
ORDER BY total_revenue DESC
LIMIT 5;



--8. Orders by Weekday
SELECT 
    CASE STRFTIME('%w', order_purchase_timestamp)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS weekday,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY weekday
ORDER BY total_orders DESC;




-- VIEW
-- 1. Top 5 States with Most Customers
CREATE VIEW top_5_states_customers AS
SELECT customer_state, COUNT(DISTINCT customer_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 5;

-- 2. Number of Unique Products per Category
CREATE VIEW unique_products_per_category AS
SELECT p.product_category_name, COUNT(DISTINCT p.product_id) AS unique_products
FROM products p
GROUP BY p.product_category_name;


-- 3. Monthly Order Trends
CREATE VIEW monthly_order_trends AS
SELECT 
    strftime('%Y-%m', order_purchase_timestamp) AS month,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;


-- 4. Revenue by Payment Type
CREATE VIEW revenue_by_payment_type AS
SELECT 
    payment_type,
    SUM(payment_value) AS total_revenue
FROM order_payments
GROUP BY payment_type;

SELECT * FROM monthly_order_trends;




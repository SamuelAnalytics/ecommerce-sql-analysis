-- =========================================
-- Monthly Revenue Analysis
-- =========================================

SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month DESC;

-- =========================================
-- Top Customers by Revenue
-- =========================================

SELECT 
    c.name AS customer,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o
    ON o.customer_id = c.id
JOIN order_items oi
    ON oi.order_id = o.id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 10;

-- =========================================
-- Top Products by Revenue
-- =========================================

SELECT 
	p.name AS product,
	SUM(oi.quantity * oi.unit_price) AS total_revenue,
	SUM(oi.quantity * oi.unit_price) AS total_sold
FROM order_items oi
JOIN products p
	ON oi.product_id = p.id
GROUP BY p.name
ORDER BY total_revenue DESC
LIMIT 10;

-- =========================================
-- Customers Witout Orders
-- =========================================

SELECT 
	c.name AS customer,
	c.email AS email,
	c.resgistration_date AS date
FROM customers c
LEFT JOIN orders o
	ON o.customer_id = c.id
WHERE c.order_id IS NULL;

-- =========================================
-- Order Details and Revenue Analysis
-- =========================================

SELECT 
	o.id AS order_id,
	c.name AS customer,
	o.order_date AS date,
	o.status,
	SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o
	ON o.customer_id = c.id
JOIN order_items oi
	ON oi.order_id = o.id
GROUP BY 
	o.id,
	c.name,
	o.order_date,
	o.status
ORDER BY total_revenue DESC
LIMIT 10;

-- =========================================
-- Average Order Value
-- =========================================

SELECT 
    AVG(order_total) AS average_order_value
FROM (
    SELECT 
        o.id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.id
    GROUP BY o.id
);

-- =========================================
-- Order Status Analysis
-- =========================================

SELECT 
	o.id AS order_id,
	c.name AS customer,
	o.order_date AS date,
	o.status AS status
FROM customers c
JOIN orders o 
	ON o.customer_id = c.id
WHERE o.status IN ('Canceled', 'Pending')
ORDER BY o.order_date DESC;


-- =========================================
-- Revenue by Category
-- =========================================

SELECT 
	ct.name AS customer,
	SUM(oi.quantity * oi.unit_price) AS total_revenue
from categories ct
JOIN products p
	ON p.category_id = ct.id
JOIN order_items oi
	ON oi.product_id = p.id
GROUP BY ct.name
ORDER BY total_revenue DESC;
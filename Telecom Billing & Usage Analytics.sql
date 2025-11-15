CREATE DATABASE IF NOT EXISTS telecom_project;
USE telecom_project;
Show databases;
-- Create Database
CREATE DATABASE IF NOT EXISTS telecom_project;
USE telecom_project;

-- Drop existing tables (optional)
DROP TABLE IF EXISTS billing;
DROP TABLE IF EXISTS usage_details;
DROP TABLE IF EXISTS customers;

------------------------------------------------
-- 1. CUSTOMERS TABLE
------------------------------------------------

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    activation_date DATE
);

INSERT INTO customers (customer_id, customer_name, region, activation_date) VALUES
(101, 'Amit Sharma', 'West', '2023-01-10'),
(102, 'Priya Rao', 'South', '2023-02-15'),
(103, 'John Mathew', 'North', '2023-04-20'),
(104, 'Neha Patil', 'West', '2023-05-05'),
(105, 'Rahul Singh', 'East', '2023-06-10');

------------------------------------------------
-- 2. USAGE DETAILS TABLE
------------------------------------------------

CREATE TABLE usage_details (
    usage_id INT PRIMARY KEY,
    customer_id INT,
    usage_date DATE,
    call_minutes INT,
    data_mb INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO usage_details (usage_id, customer_id, usage_date, call_minutes, data_mb) VALUES
(1, 101, '2023-06-01', 20, 500),
(2, 101, '2023-06-03', 10, 700),
(3, 102, '2023-06-01', 30, 400),
(4, 103, '2023-06-02', 15, 900),
(5, 104, '2023-06-03', 25, 850),
(6, 105, '2023-06-05', 40, 1000),
(7, 101, '2023-07-01', 60, 200),
(8, 103, '2023-07-02', 35, 1200);

------------------------------------------------
-- 3. BILLING TABLE
------------------------------------------------

CREATE TABLE billing (
    bill_id INT PRIMARY KEY,
    customer_id INT,
    bill_month VARCHAR(7),
    call_charge DECIMAL(10,2),
    data_charge DECIMAL(10,2),
    total_charge DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO billing (bill_id, customer_id, bill_month, call_charge, data_charge, total_charge) VALUES
(201, 101, '2023-06', 200, 350, 550),
(202, 102, '2023-06', 300, 250, 550),
(203, 103, '2023-06', 150, 450, 600),
(204, 104, '2023-06', 220, 330, 550),
(205, 105, '2023-06', 320, 400, 720),
(206, 101, '2023-07', 450, 80, 530),
(207, 103, '2023-07', 350, 500, 850);

show tables;
desc billing;
select bill_month from billing;
-- Find total call minutes & data consumed per customer in June.
SELECT 
    c.customer_name,
    SUM(u.call_minutes) AS total_minutes,
    SUM(u.data_mb) AS total_data
FROM customers c
JOIN usage_details u ON c.customer_id = u.customer_id
WHERE MONTH(u.usage_date) = 6
GROUP BY c.customer_name;
-- Find customers with no usage
SELECT c.customer_name
FROM customers c
LEFT JOIN usage_details u ON c.customer_id = u.customer_id
WHERE u.usage_id IS NULL;

-- Rank customers by highest data usage per month.
WITH usage_monthly AS (
    SELECT 
        customer_id,
        DATE_FORMAT(usage_date, '%Y-%m') AS month,
        SUM(data_mb) AS total_data
    FROM usage_details
    GROUP BY customer_id, month
)
SELECT 
    customer_id,
    month,
    total_data,
    RANK() OVER(PARTITION BY month ORDER BY total_data DESC) AS data_rank
FROM usage_monthly;
-- bill vs usage reconciliation
WITH usage_cost AS (
    SELECT 
        customer_id,
        DATE_FORMAT(usage_date, '%Y-%m') AS month,
        SUM(call_minutes) * 5 AS call_charge_calc,
        SUM(data_mb) * 0.3 AS data_charge_calc
    FROM usage_details
    GROUP BY customer_id, month
)
SELECT 
    b.customer_id,
    b.bill_month,
    b.total_charge AS billed_amount,
    (u.call_charge_calc + u.data_charge_calc) AS calculated_amount,
    b.total_charge - (u.call_charge_calc + u.data_charge_calc) AS difference
FROM billing b
JOIN usage_cost u 
ON b.customer_id = u.customer_id AND b.bill_month = u.month;
-- Running Total
SELECT 
    customer_id,
    bill_month,
    total_charge,
    SUM(total_charge) OVER (PARTITION BY customer_id ORDER BY bill_month) AS running_total
FROM billing;
-- usage classification
SELECT 
    customer_id,
    data_mb,
    CASE 
        WHEN data_mb > 1000 THEN 'High'
        WHEN data_mb > 500 THEN 'Medium'
        ELSE 'Low'
    END AS usage_level
FROM usage_details;
-- customers above average usage
SELECT customer_id
FROM usage_details
GROUP BY customer_id
HAVING SUM(data_mb) > (
    SELECT AVG(total_data)
    FROM (
        SELECT SUM(data_mb) AS total_data 
        FROM usage_details 
        GROUP BY customer_id
    ) AS t
);

-- Detect missing bills
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN billing b ON c.customer_id = b.customer_id
WHERE b.bill_id IS NULL;
-- Find month with highest revenue
SELECT bill_month, SUM(total_charge) AS monthly_revenue
FROM billing
GROUP BY bill_month
ORDER BY monthly_revenue DESC
LIMIT 1;

SELECT 
    c.customer_name,
    b.bill_month,
    b.total_charge,
    RANK() OVER (ORDER BY b.total_charge DESC) AS revenue_rank
FROM billing b
JOIN customers c ON b.customer_id = c.customer_id;













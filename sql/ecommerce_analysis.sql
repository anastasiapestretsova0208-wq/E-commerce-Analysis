/*
E-commerce Performance Analysis
Database: PostgreSQL

Business Questions:
1. How did profit change in March 2015 compared with March 2014?
2. How many customers were attracted by marketing campaigns,
   and how many of them made a purchase?
3. What percentage of customers made two or more purchases?
*/


-- ============================================================
-- 1. PROFIT PERFORMANCE
-- Compare March 2015 profit with March 2014
-- ============================================================

WITH profit_by_year AS (
    SELECT
        DATE_TRUNC('month', created_at)::date AS month,
        SUM(price_usd) AS revenue,
        SUM(cogs_usd) AS cogs,
        SUM(price_usd) - SUM(cogs_usd) AS profit,
        LAG(SUM(price_usd) - SUM(cogs_usd)) OVER (
            ORDER BY DATE_TRUNC('month', created_at)::date
        ) AS previous_profit
    FROM orders
    WHERE DATE_TRUNC('month', created_at)::date IN (
        DATE '2014-03-01',
        DATE '2015-03-01'
    )
    GROUP BY DATE_TRUNC('month', created_at)::date
)

SELECT
    month,
    profit,
    previous_profit,
    profit - previous_profit AS profit_change,
    ROUND(
        ((profit - previous_profit) / previous_profit) * 100,
        2
    ) AS profit_change_percent
FROM profit_by_year
ORDER BY month;


-- ============================================================
-- 2. MARKETING CAMPAIGN PERFORMANCE
-- Compare unique visitors, buyers, orders, and conversion rate
-- ============================================================

SELECT
    ws.utm_campaign,
    COUNT(DISTINCT ws.user_id) AS visitors,
    COUNT(DISTINCT o.user_id) AS buyers,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        COUNT(DISTINCT o.user_id) * 100.0
        / NULLIF(COUNT(DISTINCT ws.user_id), 0),
        2
    ) AS conversion_rate
FROM website_sessions AS ws
LEFT JOIN orders AS o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_campaign
ORDER BY visitors DESC;


-- ============================================================
-- 3. CUSTOMER RETENTION
-- Calculate customers with two or more orders
-- ============================================================

WITH customer_orders AS (
    SELECT
        user_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM orders
    GROUP BY user_id
),

customer_summary AS (
    SELECT
        COUNT(*) FILTER (WHERE order_count >= 2) AS repeat_customers,
        COUNT(*) AS all_customers
    FROM customer_orders
)

SELECT
    repeat_customers,
    all_customers,
    ROUND(
        repeat_customers * 100.0 / all_customers,
        2
    ) AS repeat_customer_rate
FROM customer_summary;

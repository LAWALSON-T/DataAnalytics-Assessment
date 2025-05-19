-- Calculate customers with both savings and investment plans, showing counts and total deposits
WITH savings AS (
    SELECT s.owner_id,
           COUNT(DISTINCT s.plan_id) AS savings_count,
           SUM(s.confirmed_amount) AS savings_total
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_regular_savings = 1
    AND s.confirmed_amount > 0
    GROUP BY s.owner_id
),
investments AS (
    SELECT s.owner_id,
           COUNT(DISTINCT s.plan_id) AS investment_count,
           SUM(s.confirmed_amount) AS investment_total
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_a_fund = 1
    AND s.confirmed_amount > 0
    GROUP BY s.owner_id
)
SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    s.savings_count,
    i.investment_count,
    ROUND((s.savings_total + i.investment_total) / 100, 2) AS total_deposits -- convert to naira
FROM savings s
JOIN investments i ON s.owner_id = i.owner_id
JOIN users_customuser u ON u.id = s.owner_id
ORDER BY total_deposits DESC;

-- Identify savings/investment plans with no inflow in the last 365 days


SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
    END AS type,
    COALESCE(
        MAX(s.transaction_date),
        DATE_SUB(CURDATE(), INTERVAL 365 DAY)
    ) AS last_transaction_date,
    LEAST(
        DATEDIFF(CURDATE(), COALESCE(MAX(s.transaction_date), DATE_SUB(CURDATE(), INTERVAL 365 DAY))),
        365
    ) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s
    ON p.id = s.plan_id
    AND s.confirmed_amount > 0 -- only inflows
WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1
GROUP BY p.id, p.owner_id, type
HAVING inactivity_days >= 365
ORDER BY inactivity_days DESC;

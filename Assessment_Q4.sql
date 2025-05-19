-- Step 1: Aggregate transaction data per customer
WITH transaction_data AS (
    SELECT 
        sa.owner_id,
        SUM(sa.confirmed_amount) AS total_transaction_value,
        COUNT(sa.id) AS total_transactions
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
),

-- Step 2: Calculate tenure in months for each customer
tenure_data AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM users_customuser u
),

-- Step 3: Estimate CLV based on simplified profit model
clv_calculation AS (
    SELECT 
        td.owner_id AS customer_id,
        tn.name,
        tn.tenure_months,
        td.total_transactions,
        td.total_transaction_value,
        
        -- Average profit per transaction (0.1% of value per transaction)
        td.total_transaction_value * 0.001 / td.total_transactions AS avg_profit_per_transaction,
        
        -- Estimated CLV: normalized to a yearly figure based on tenure
        td.total_transactions / NULLIF(tn.tenure_months, 0) * 12 
            * (td.total_transaction_value * 0.001 / td.total_transactions) AS estimated_clv
    FROM transaction_data td
    JOIN tenure_data tn ON td.owner_id = tn.customer_id
)

-- Final output
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(estimated_clv, 2) AS estimated_clv
FROM clv_calculation
ORDER BY estimated_clv DESC;

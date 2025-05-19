-- Calculate average transactions per customer per month and categorize by frequency

WITH customer_txn_summary AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        MIN(transaction_date) AS first_txn_date, -- capture first transaction date 
        MAX(transaction_date) AS last_txn_date -- capture last transaction date 
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),
customer_tenure AS (
    SELECT
        owner_id,
        total_transactions,
        first_txn_date,
        last_txn_date,
        -- Calculate tenure in months; add 1 to avoid division by zero if only one month
        TIMESTAMPDIFF(MONTH, first_txn_date, last_txn_date) + 1 AS tenure_months
    FROM customer_txn_summary
),
frequency_categorized AS (
    SELECT
        ct.owner_id,
        u.first_name,
        u.last_name,
        ct.total_transactions,
        ct.tenure_months,
        ROUND(ct.total_transactions / ct.tenure_months, 2) AS avg_txn_per_month,
        CASE
            WHEN (ct.total_transactions / ct.tenure_months) >= 10 THEN 'High Frequency'
            WHEN (ct.total_transactions / ct.tenure_months) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_tenure ct
    JOIN users_customuser u ON u.id = ct.owner_id
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM frequency_categorized
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');

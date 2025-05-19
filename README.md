# DataAnalytics-Assessment
SQL Proficiency Assessment

## QUESTION 1
### Walkthrough & Thought Process
This task required a deep understanding of the database structure—particularly the misleadingly named savings_savingsaccount table.
At first glance, one might assume this table stores actual savings accounts, but upon inspection, it functions as a transaction table, containing deposit records for both savings and investment plans.

The hint provided valuable context:
A savings plan is identified by is_regular_savings = 1
An investment plan is identified by is_a_fund = 1

### Steps Taken
Created CTEs (Common Table Expressions):

*One for funded savings plans by filtering on is_regular_savings = 1 and joining with the transactions table for deposits (confirmed_amount > 0).

*Another for funded investment plans using is_a_fund = 1 and the same logic for filtering funded deposits.

*Joined both CTEs on owner_id to get only customers who have both types of plans.

*Joined the result with the users_customuser table to retrieve full customer names by concatenating first_name and last_name.

*Summed deposit values from both plan types, converting from Kobo to Naira by dividing confirmed_amount by 100.

*Sorted the final result by total deposits in descending order.

## QUESTION 2
### Walkthrough & Thought Process
Task 2 was a bit more straightforward , the only issue was figuring out the range of dates to look at in regards the transaction count , initially wanted to go for 12 months as its usually best to analyze recent customer behavior. as if you pick too short or too long your result mught bbe skewed .seeing as no time period was specified I decided to use all available transaction data to ensure a complete picture of each customer’s activity.

To segment customers based on their transaction frequency, I calculated the tenure of each customer in months using the date_joined field. Then I counted the total number of confirmed transactions (i.e., deposits) per customer and divided it by their tenure in months to get the average number of transactions per month.

### Steps Taken
*Calculated each customer’s tenure in months using TIMESTAMPDIFF on their date_joined.

*Aggregated all deposit transactions per customer from the savings_savingsaccount table, using only confirmed_amount > 0 to ensure only actual deposits were counted.

*Computed the average transactions per month as total_transactions / tenure_months.

*Used a CASE statement to categorize customers into frequency groups.

*Returned a summary of how many customers fall into each frequency group and their average monthly transactions.

## QUESTION 3
### Walkthrough & Thought Process
With the insights and logic developed from solving Questions 1 and 2, Task 3 required less time. The question required identifying all savings or investment plans that have not received any inflows in the past 365 days. With the logic of savings (is_regular_savings = 1) or an investment (is_a_fund = 1), I just needed to find those within this filter with no deposits or inflows, deposit records are stored in the savings_savingsaccount table ,so inflow ckeck was done on the savings account table while using the plan table to filter for the identifiers

### Steps Taken
*Filtered plans to include only those that are either savings or investment based on their respective boolean flags.

*Performed a LEFT JOIN on the savings_savingsaccount table to associate plans with any inflow transactions (confirmed_amount > 0).

*Used MAX(s.transaction_date) to get the date of the last inflow per plan.

*Applied COALESCE to substitute a default value (365 days ago) for plans that have never had any inflows.

*Calculated the number of inactive days using DATEDIFF, and capped it at 365 using LEAST.

*Used a HAVING clause to return only those plans with inactivity >= 365 days.

*Ordered results in descending order of inactivity.


## QUESTION 4
### Walkthrough & Thought Process
This task required estimating the Customer Lifetime Value (CLV) using available transaction and user data. The core challenge was to build a simplified yet meaningful metric for CLV
To address this, I used a simplified profit-per-transaction model, assuming an average profit of 0.1% per transaction value. I also normalized CLV to a yearly figure by taking tenure (in months) into account.

### Steps Taken
*Queried the savings_savingsaccount table to sum up all confirmed transaction amounts (confirmed_amount) and count the number of transactions per owner_id.

*This step provided the total transaction value and total number of transactions per customer.

*Queried the users_customuser table to get each customer’s date_joined.

*Used TIMESTAMPDIFF(MONTH, ...) to calculate tenure in months between date_joined and the current date.

*Used this formula Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)

*Assumed 0.1% of each transaction’s value as profit, Normalized the average profit to an annual estimate using the tenure in months

*Returned the customer’s full name, tenure, total transactions, and a rounded CLV value.

*Sorted the result in descending order to highlight the highest-value customers.

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




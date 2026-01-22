-- ============================================
-- Outstanding Exposure by Cohort
-- ============================================

WITH cohort_outstanding AS (
    SELECT
        client_cohort,
        SUM(total_loan_disbursed_amount - paid_amount) AS outstanding_balance
    FROM loans
    GROUP BY client_cohort
)

SELECT
    client_cohort,
    outstanding_balance,
    ROUND(
        outstanding_balance / SUM(outstanding_balance) OVER (),
        4
    ) AS pct_of_portfolio
FROM cohort_outstanding
ORDER BY outstanding_balance DESC;

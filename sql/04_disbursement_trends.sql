-- ============================================
-- Month-over-Month Disbursement Trend
-- ============================================

WITH cohort_disbursement AS (
    SELECT
        client_cohort,
        SUM(total_loan_disbursed_amount) AS total_disbursed
    FROM loans
    GROUP BY client_cohort
)

SELECT
    client_cohort,
    total_disbursed,
    total_disbursed
        - LAG(total_disbursed) OVER (ORDER BY client_cohort)
        AS mom_disbursed_change
FROM cohort_disbursement
ORDER BY client_cohort;

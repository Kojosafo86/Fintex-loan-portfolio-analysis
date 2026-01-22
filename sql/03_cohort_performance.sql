-- ============================================
-- Cohort Repayment Performance
-- Best and worst performing cohorts
-- ============================================

SELECT
    client_cohort,
    COUNT(loan_id)                   AS number_of_loans,
    SUM(total_loan_disbursed_amount) AS total_disbursed,
    SUM(paid_amount)                 AS total_repaid,
    ROUND(
        SUM(paid_amount) / NULLIF(SUM(total_loan_disbursed_amount), 0),
        4
    ) AS repayment_rate
FROM loans
GROUP BY client_cohort
ORDER BY repayment_rate DESC;

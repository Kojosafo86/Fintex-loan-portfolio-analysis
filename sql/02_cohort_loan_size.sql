-- ============================================
-- Average Loan Size by Cohort
-- ============================================

SELECT
    client_cohort,
    COUNT(loan_id)                   AS number_of_loans,
    SUM(total_loan_disbursed_amount) AS total_disbursed,
    ROUND(
        SUM(total_loan_disbursed_amount) / COUNT(loan_id),
        2
    ) AS avg_loan_size
FROM loans
GROUP BY client_cohort
ORDER BY client_cohort;

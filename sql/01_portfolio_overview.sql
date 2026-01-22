-- ============================================
-- Portfolio Overview
-- High-level snapshot of the loan book
-- ============================================

SELECT
    SUM(total_loan_disbursed_amount)               AS total_disbursed,
    SUM(paid_amount)                               AS total_repaid,
    SUM(total_loan_disbursed_amount - paid_amount) AS total_outstanding,
    ROUND(
        SUM(paid_amount) / NULLIF(SUM(total_loan_disbursed_amount), 0),
        4
    ) AS portfolio_repayment_rate
FROM loans;


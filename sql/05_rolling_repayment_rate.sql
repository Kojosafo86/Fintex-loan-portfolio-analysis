-- ============================================
-- Rolling 3-Month Repayment Rate
-- ============================================

SELECT
    client_cohort,
    ROUND(
        AVG(
            paid_amount * 1.0
            / NULLIF(total_loan_disbursed_amount, 0)
        ) OVER (
            ORDER BY client_cohort
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        4
    ) AS rolling_3m_repayment_rate
FROM loans
ORDER BY client_cohort;

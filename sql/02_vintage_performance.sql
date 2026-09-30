-- =====================================================================
-- 02_vintage_performance.sql
-- Quarterly vintages (by DISBURSEMENT date). Loss and on-time rates use
-- matured loans only; the maturity column shows how complete each
-- vintage's outcome is.
-- =====================================================================

SELECT
    vintage_quarter,
    COUNT(*)                                                    AS loans,
    SUM(principal)                                              AS principal_disbursed,
    ROUND(AVG(principal), 0)                                    AS avg_loan_size,
    ROUND(AVG(CAST(is_matured AS INT)), 3)                      AS share_matured,
    ROUND(SUM(principal_shortfall) FILTER (WHERE is_matured)
          / NULLIF(SUM(principal) FILTER (WHERE is_matured), 0), 4)
                                                                AS principal_loss_rate,
    ROUND(AVG(CAST(settled_on_time AS INT)) FILTER (WHERE is_matured), 3)
                                                                AS settled_on_time_rate,
    ROUND(AVG(CAST(loan_number = 0 AS INT)), 3)                 AS share_first_loans
FROM loans
GROUP BY vintage_quarter
ORDER BY vintage_quarter;

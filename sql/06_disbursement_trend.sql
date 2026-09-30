-- =====================================================================
-- 06_disbursement_trend.sql
-- Monthly lending volume and month-over-month change (LAG), at the
-- correct loan grain.
-- =====================================================================

WITH monthly AS (
    SELECT
        vintage_month,
        COUNT(*)       AS loans,
        SUM(principal) AS principal_disbursed
    FROM loans
    GROUP BY vintage_month
)
SELECT
    STRFTIME(vintage_month, '%Y-%m')                            AS month,
    loans,
    principal_disbursed,
    principal_disbursed - LAG(principal_disbursed) OVER (ORDER BY vintage_month)
                                                                AS mom_change,
    ROUND(AVG(principal_disbursed) OVER (ORDER BY vintage_month
                                         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0)
                                                                AS rolling_3m_avg_disbursed
FROM monthly
ORDER BY vintage_month;

-- =====================================================================
-- 07_outstanding_exposure.sql
-- What is still owed as at the snapshot, split into loans still inside
-- their repayment window (open) and loans past maturity that were never
-- settled (arrears / write-off candidates).
-- =====================================================================

SELECT
    CASE WHEN is_matured THEN 'Past maturity, unsettled'
         ELSE 'Open (still in repayment window)' END   AS status,
    COUNT(*)                                            AS loans,
    ROUND(SUM(GREATEST(total_due - total_paid, 0)), 0)  AS amount_still_due,
    ROUND(SUM(principal_shortfall), 0)                  AS principal_not_recovered
FROM loans
WHERE NOT is_settled
GROUP BY 1
ORDER BY 1;

-- Where the unrecovered principal sits, by vintage
SELECT
    vintage_quarter,
    ROUND(SUM(principal_shortfall), 0)                              AS principal_not_recovered,
    ROUND(SUM(principal_shortfall)
          / SUM(SUM(principal_shortfall)) OVER (), 4)               AS share_of_total
FROM loans
WHERE is_matured
GROUP BY vintage_quarter
ORDER BY vintage_quarter;

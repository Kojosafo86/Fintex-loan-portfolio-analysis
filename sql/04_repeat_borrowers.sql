-- =====================================================================
-- 04_repeat_borrowers.sql
-- Does performance improve as clients take more loans?
-- LOAN_NUMBER counts a client's previous loans (0 = first loan).
-- =====================================================================

SELECT
    CASE
        WHEN loan_number = 0  THEN '1. First loan'
        WHEN loan_number <= 4 THEN '2. Loans 2-5'
        WHEN loan_number <= 9 THEN '3. Loans 6-10'
        WHEN loan_number <= 19 THEN '4. Loans 11-20'
        ELSE                       '5. Loan 21+'
    END                                                         AS borrower_stage,
    COUNT(*)                                                    AS matured_loans,
    ROUND(AVG(principal), 0)                                    AS avg_loan_size,
    ROUND(SUM(principal_shortfall) / SUM(principal), 4)         AS principal_loss_rate,
    ROUND(AVG(CAST(settled_on_time AS INT)), 3)                 AS settled_on_time_rate
FROM loans
WHERE is_matured
GROUP BY 1
ORDER BY 1;

-- Client journeys: what happened after a client's FIRST loan?
-- (Every client in this extract took their first loan in 2020.)
WITH first_loan AS (
    SELECT client_id, principal_shortfall > 0 AS first_loan_short
    FROM loans
    WHERE loan_number = 0 AND is_matured
),
per_client AS (
    SELECT client_id, COUNT(*) AS loans_taken
    FROM loans
    GROUP BY client_id
)
SELECT
    CASE WHEN f.first_loan_short THEN 'Did not repay first loan in full'
         ELSE 'Repaid first loan' END                           AS first_loan_outcome,
    COUNT(*)                                                    AS clients,
    ROUND(AVG(c.loans_taken), 1)                                AS avg_loans_per_client
FROM first_loan f
JOIN per_client c USING (client_id)
GROUP BY 1
ORDER BY 1;

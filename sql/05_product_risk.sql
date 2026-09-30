-- =====================================================================
-- 05_product_risk.sql
-- Loss by repayment tenor and by loan size, matured loans only.
-- The second query holds loan size roughly constant (1,500-2,999) to
-- check the tenor effect isn't just a loan-size effect in disguise.
-- =====================================================================

-- By number of instalments
SELECT
    num_installments,
    COUNT(*)                                            AS matured_loans,
    ROUND(AVG(principal), 0)                            AS avg_loan_size,
    ROUND(SUM(principal_shortfall) / SUM(principal), 4) AS principal_loss_rate,
    MIN(disbursement_date)                              AS first_issued
FROM loans
WHERE is_matured
GROUP BY num_installments
ORDER BY num_installments;

-- Same loan-size band, short vs long tenor
SELECT
    CASE WHEN num_installments <= 3 THEN '1-3 instalments'
         ELSE '4-6 instalments' END                     AS tenor,
    COUNT(*)                                            AS matured_loans,
    ROUND(SUM(principal_shortfall) / SUM(principal), 4) AS principal_loss_rate
FROM loans
WHERE is_matured
  AND principal BETWEEN 1500 AND 2999
GROUP BY 1
ORDER BY 1;

-- By loan size band
SELECT
    CASE WHEN principal < 300  THEN '1. under 300'
         WHEN principal < 700  THEN '2. 300-699'
         WHEN principal < 1500 THEN '3. 700-1,499'
         ELSE                       '4. 1,500+' END     AS size_band,
    COUNT(*)                                            AS matured_loans,
    ROUND(SUM(principal_shortfall) / SUM(principal), 4) AS principal_loss_rate
FROM loans
WHERE is_matured
GROUP BY 1
ORDER BY 1;

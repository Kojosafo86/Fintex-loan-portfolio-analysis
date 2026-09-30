-- =====================================================================
-- 03_vintage_curves.sql
-- Classic vintage curve: cumulative net collections as a share of
-- principal, by months on book, for each quarterly vintage.
-- A vintage that sits lower at the same month-on-book is repaying slower.
-- Months on book are capped at 12 (almost all loans are 1-3 instalments).
-- =====================================================================

WITH mob AS (
    SELECT
        l.vintage_quarter,
        LEAST(DATE_DIFF('month', l.disbursement_date, p.payment_date), 12) AS months_on_book,
        SUM(p.paid_amount) AS paid
    FROM payments p
    JOIN loans l USING (loan_id)
    GROUP BY 1, 2
),
vintage_principal AS (
    SELECT vintage_quarter, SUM(principal) AS principal
    FROM loans
    GROUP BY 1
),
grid AS (   -- every vintage x month 0..12, so months with no payments still appear
    SELECT v.vintage_quarter, m.months_on_book
    FROM vintage_principal v
    CROSS JOIN (SELECT UNNEST(RANGE(0, 13)) AS months_on_book) m
)
SELECT
    g.vintage_quarter,
    g.months_on_book,
    ROUND(
        SUM(COALESCE(mob.paid, 0)) OVER (PARTITION BY g.vintage_quarter
                                         ORDER BY g.months_on_book)
        / vp.principal, 4)                                  AS cumulative_collected_pct_of_principal
FROM grid g
JOIN vintage_principal vp USING (vintage_quarter)
LEFT JOIN mob USING (vintage_quarter, months_on_book)
ORDER BY g.vintage_quarter, g.months_on_book;

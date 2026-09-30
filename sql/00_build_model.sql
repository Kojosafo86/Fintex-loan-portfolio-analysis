-- =====================================================================
-- 00_build_model.sql
-- Turns the raw payment-transaction extract into three analysis tables
-- at the correct grain. Everything else in this project reads from these.
--
-- Why this step matters: the raw file has ONE ROW PER PAYMENT TRANSACTION
-- (a loan with 3 instalments and several part-payments appears many times).
-- Loan-level columns such as TOTAL_LOAN_DISBURSED_AMOUNT repeat on every
-- row, so summing them straight from the raw file overstates the book
-- roughly 3x. Each table below is deduplicated to its own grain first.
--
-- Dialect: DuckDB (standard SQL; runs with minor changes on PostgreSQL).
-- Expects a table `raw` loaded from data/smaller_data_set.csv.
-- =====================================================================

-- Snapshot date = last transaction in the extract. Loans are judged
-- "as at" this date.
CREATE OR REPLACE TABLE snapshot AS
SELECT CAST(MAX(transaction_date) AS DATE) AS snapshot_date FROM raw;

-- ---------------------------------------------------------------------
-- 1. installments: one row per loan instalment (contractual schedule)
-- ---------------------------------------------------------------------
CREATE OR REPLACE TABLE installments AS
SELECT
    loan_id,
    installment                             AS installment_no,
    MAX(installment_disbursed_amount)       AS principal_component,
    MAX(installment_total_due)              AS amount_due,
    CAST(MAX(installment_due_date) AS DATE) AS due_date
FROM raw
GROUP BY loan_id, installment;

-- ---------------------------------------------------------------------
-- 2. payments: one row per payment transaction.
--    Negative amounts are reversals / reallocations between instalments
--    of the same loan, so payments are netted at LOAN level, not
--    instalment level.
-- ---------------------------------------------------------------------
CREATE OR REPLACE TABLE payments AS
SELECT
    loan_id,
    installment                    AS installment_no,
    CAST(transaction_date AS DATE) AS payment_date,
    paid_amount
FROM raw
WHERE transaction_date IS NOT NULL
  AND paid_amount IS NOT NULL;

-- ---------------------------------------------------------------------
-- 3. loans: one row per loan, with repayment outcome as at snapshot
-- ---------------------------------------------------------------------
CREATE OR REPLACE TABLE loans AS
WITH loan_base AS (
    SELECT
        loan_id,
        MAX(client_id)                              AS client_id,
        MAX(loan_number)                            AS loan_number,   -- 0 = client's first loan
        CAST(MAX(loan_disbursement_date) AS DATE)   AS disbursement_date,
        MAX(total_loan_disbursed_amount)            AS principal,
        MAX(num_installments)                       AS num_installments
    FROM raw
    GROUP BY loan_id
),
schedule AS (
    SELECT loan_id,
           SUM(amount_due) AS total_due,
           MAX(due_date)   AS final_due_date
    FROM installments
    GROUP BY loan_id
),
paid AS (
    SELECT loan_id, SUM(paid_amount) AS total_paid
    FROM payments
    GROUP BY loan_id
),
-- running net payments, to find the day each loan was fully settled
running AS (
    SELECT loan_id, payment_date,
           SUM(paid_amount) OVER (PARTITION BY loan_id ORDER BY payment_date
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_paid
    FROM payments
),
settled AS (
    SELECT r.loan_id, MIN(r.payment_date) AS settled_date
    FROM running r
    JOIN schedule s USING (loan_id)
    WHERE r.cum_paid >= 0.99 * s.total_due        -- 1% tolerance for rounding
    GROUP BY r.loan_id
)
SELECT
    b.*,
    DATE_TRUNC('month', b.disbursement_date)                 AS vintage_month,
    CAST(YEAR(b.disbursement_date) AS VARCHAR) || '-Q'
        || CAST(QUARTER(b.disbursement_date) AS VARCHAR)      AS vintage_quarter,
    s.total_due,
    s.final_due_date,
    COALESCE(p.total_paid, 0)                                AS total_paid,
    st.settled_date,
    -- Matured = final instalment fell due at least 60 days before the
    -- snapshot, so the outcome is known rather than still in progress.
    (s.final_due_date <= sn.snapshot_date - INTERVAL 60 DAY) AS is_matured,
    (st.settled_date IS NOT NULL)                            AS is_settled,
    COALESCE(st.settled_date <= s.final_due_date, FALSE)     AS settled_on_time,   -- never settled = not on time
    (st.settled_date > s.final_due_date + INTERVAL 30 DAY)   AS settled_30plus_late,
    -- Principal loss: a matured loan that never paid back its principal.
    GREATEST(b.principal - COALESCE(p.total_paid, 0), 0)     AS principal_shortfall
FROM loan_base b
JOIN schedule s   USING (loan_id)
LEFT JOIN paid p  USING (loan_id)
LEFT JOIN settled st USING (loan_id)
CROSS JOIN snapshot sn;

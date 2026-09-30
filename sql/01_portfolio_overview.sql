-- =====================================================================
-- 01_portfolio_overview.sql
-- Headline view of the book. Loss metrics use MATURED loans only
-- (final instalment due 60+ days before the snapshot), because a loan
-- still inside its repayment window hasn't had the chance to repay.
-- =====================================================================

SELECT
    COUNT(*)                                                        AS loans,
    COUNT(DISTINCT client_id)                                       AS clients,
    SUM(principal)                                                  AS principal_disbursed,
    ROUND(AVG(principal), 0)                                        AS avg_loan_size,
    SUM(total_due)                                                  AS contractual_due,
    ROUND(SUM(total_paid), 2)                                       AS net_collected,
    -- matured book only
    COUNT(*) FILTER (WHERE is_matured)                              AS matured_loans,
    ROUND(SUM(total_paid) FILTER (WHERE is_matured)
          / SUM(principal) FILTER (WHERE is_matured), 4)            AS matured_collected_per_unit_lent,
    ROUND(SUM(principal_shortfall) FILTER (WHERE is_matured)
          / SUM(principal) FILTER (WHERE is_matured), 4)            AS matured_principal_loss_rate,
    ROUND(AVG(CAST(settled_on_time AS INT)) FILTER (WHERE is_matured), 4)
                                                                    AS matured_settled_on_time_rate
FROM loans;

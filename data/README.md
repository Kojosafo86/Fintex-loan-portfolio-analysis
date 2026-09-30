# Data

The source dataset is not included in this repository. It was supplied as a
confidential case study during a job interview, so only the code, aggregated
results and charts are published here.

To re-run the analysis with your own copy, save it as `data/smaller_data_set.csv`
with these columns (one row per payment transaction):

| Column | Meaning |
|---|---|
| CLIENT_ID | Client identifier |
| LOAN_NUMBER | Client's previous loan count (0 = first loan) |
| LOAN_ID | Loan identifier |
| LOAN_DISBURSEMENT_DATE | Disbursement timestamp |
| TOTAL_LOAN_DISBURSED_AMOUNT | Principal lent (GHS) |
| NUM_INSTALLMENTS | Number of instalments |
| INSTALLMENT | Instalment number |
| INSTALLMENT_DISBURSED_AMOUNT | Principal component of the instalment |
| INSTALLMENT_DUE_DATE | Instalment due date |
| INSTALLMENT_TOTAL_DUE | Amount due on the instalment (incl. fees) |
| TRANSACTION_DATE | Payment timestamp |
| PAID_AMOUNT | Payment amount (negative = reversal) |
| CLIENT_COHORT | Month of the client's first loan |

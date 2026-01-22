# 📊 Fintech Loan Portfolio Analytics (SQL)

##  Project Overview
This project analyses a **fintech loan portfolio** using **SQL-based cohort (vintage) analysis** to understand portfolio growth, repayment performance, and risk exposure over time.

The analysis mirrors real-world **credit portfolio monitoring** used by fintech lenders, banks, and financial services teams to track capital deployment, recovery, and outstanding exposure.

---

## Business Questions
This project answers key commercial and risk-focused questions:

- How large is the overall loan portfolio?
- How much capital has been **disbursed vs repaid**?
- Which customer cohorts perform **best and worst**?
- Where is **outstanding exposure** concentrated?
- Is loan performance **improving or deteriorating** over time?

---

## Dataset Description
The dataset consists of **loan-level records** grouped into **monthly customer cohorts**.

Each record includes:
- Loan ID
- Client cohort (origination month)
- Total loan disbursed amount
- Amount repaid

Cohorts represent loans originated in the same month, enabling vintage-level performance analysis.

---

## Key KPIs & Metrics
The SQL queries calculate the following metrics:

- **Total loans issued**
- **Total amount disbursed**
- **Total amount repaid**
- **Outstanding loan balance**
- **Portfolio repayment rate**
- **Average loan size per cohort**
- **Month-over-month disbursement growth**
- **Rolling 3-month repayment rate**
- **Outstanding exposure concentration by cohort**

---

## SQL Techniques Used
This project demonstrates strong analytical SQL skills, including:

- Aggregations and financial ratios
- Window functions (`LAG`, rolling averages)
- Cohort (vintage) analysis
- Time-series trend analysis
- Exposure and concentration metrics

---

## 📁 Repository Structure
```text
fintech-loan-portfolio-analytics/
│
├── README.md
│
├── data/
│   └── loans.csv
│
├── sql/
│   ├── 01_portfolio_overview.sql
│   ├── 02_cohort_loan_size.sql
│   ├── 03_cohort_performance.sql
│   ├── 04_disbursement_trends.sql
│   ├── 05_rolling_repayment_rate.sql
│   └── 06_exposure_concentration.sql
│
└── insights/
    └── key_findings.md

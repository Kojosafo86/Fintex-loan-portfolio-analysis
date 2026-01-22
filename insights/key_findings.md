# Key Findings & Insights

This section summarises the business insights generated from the SQL analysis of the fintech loan portfolio.

---

## 1️⃣ Portfolio Health Overview
- The portfolio shows a **material gap between total disbursed and total repaid**, indicating ongoing exposure.
- While repayments are strong overall, a non-trivial portion of capital remains outstanding, highlighting the importance of cohort-level monitoring rather than portfolio-level averages alone.

**Business implication:**  
High-level repayment rates can mask underlying cohort risk if exposure is concentrated in recent or weaker vintages.

---

## 2️⃣ Cohort Performance Varies Significantly
- Earlier cohorts demonstrate **higher and more stable repayment rates**.
- More recent cohorts tend to underperform relative to historical averages.
- This pattern may reflect changes in:
  - Credit policy
  - Customer mix
  - Macroeconomic conditions

**Business implication:**  
Newer cohorts should be closely monitored and potentially subject to tighter underwriting or revised pricing.

---

## 3️⃣ Average Loan Size Has Increased Over Time
- Average loan sizes vary by cohort, with a general trend toward **larger ticket sizes** in later cohorts.
- Larger loans amplify risk when repayment performance deteriorates.

**Business implication:**  
Loan growth driven by larger disbursements should be balanced with enhanced credit controls.

---

## 4️⃣ Disbursement Growth Is Not Linear
- Month-over-month disbursement changes fluctuate, indicating **uneven portfolio growth**.
- Periods of rapid growth are followed by slower or negative changes.

**Business implication:**  
Sudden growth spurts may precede higher default or delinquency risk if credit quality is not maintained.

---

## 5️⃣ Rolling Repayment Rates Show Early Warning Signals
- The rolling 3-month repayment rate smooths volatility and highlights **directional trends**.
- A downward trend in rolling repayment performance suggests **emerging credit risk** before it appears in static metrics.

**Business implication:**  
Rolling metrics are more effective for proactive risk management than point-in-time repayment rates.

---

## 6️⃣ Exposure Is Concentrated in Recent Cohorts
- Outstanding balances are disproportionately concentrated in the most recent cohorts.
- These cohorts have had less time to repay and carry the highest capital-at-risk.

**Business implication:**  
Portfolio risk is forward-looking — current exposure depends more on recent cohorts than historical performance.

---

## 🔎 Overall Conclusion
This analysis demonstrates that:
- Portfolio-level metrics alone are insufficient for risk management
- Cohort (vintage) analysis provides critical insight into credit quality
- Growth, loan size, and repayment performance must be evaluated together

The SQL-driven approach enables fintech stakeholders to **monitor risk, guide credit strategy, and allocate capital more effectively**.

---

## 📈 Recommended Next Steps
- Introduce **default or delinquency indicators**
- Segment cohorts by **risk bands or customer type**
- Visualise trends using **Power BI or Tableau**
- Automate cohort monitoring in a production data pipeline


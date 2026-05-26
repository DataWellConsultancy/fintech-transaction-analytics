# Case Study — Financial Transaction Analytics

**Prepared by:** Datawell Consultancy
**Sector:** Fintech & Financial Services
**Scope:** Data Engineering, KPI Analytics & Business Insights

---

## 1. The Situation

A growing fintech company processing millions of transactions annually had built its operations on three separate data systems that had never been formally connected or audited. Customer profiles lived in one system, card records in another, and transaction logs in a third. None of these sources spoke to each other.

The consequence was that despite processing significant transaction volume, the business was flying blind. Leadership had no single reliable view of performance. Operations teams were spending days each month manually reconciling figures that were still unreliable when they arrived. There was no agreed definition of what a successful transaction even meant across teams.

**The business could not answer these questions with confidence:**

- What is our actual transaction success and error rate across channels?
- Which customer segments and income groups generate the most revenue?
- Which merchant categories carry the highest transaction values and where are errors concentrated?
- What does our card portfolio look like across brands, types, and risk profiles?
- When during the day and week does transaction volume peak and what does that mean for operations?

Datawell Consultancy was engaged to build the data foundation that would answer these questions — reliably, repeatably, and in a form the business could act on.

---

## 2. Our Approach

We structured the engagement in two sequential phases. The first established data quality and a unified data model. The second built the analytics layer on top of it. Nothing in Phase 2 was started until Phase 1 was complete — because analytics built on uncleaned data produces unreliable results.

| Phase | Focus | What Was Delivered |
|-------|-------|-------------------|
| Phase 1 | Data Quality & Engineering | Full audit of all three datasets across completeness, uniqueness, validity, and business rule compliance. Cleaning pipeline built in Python and DuckDB. Twelve new derived analytical columns engineered. All three tables joined into a single unified master dataset of 30+ columns. |
| Phase 2 | KPI Analytics & Insights | Eight KPI modules covering transaction volume trends, channel performance, error analysis, merchant category performance, customer segmentation, card portfolio analysis, and transaction timing patterns. Six concrete business insights with specific prioritised recommendations. |

### Data Sources

| File | Volume | Content |
|------|--------|---------|
| `users_data.csv` | 2,000 records | Customer demographics, income, credit score, debt profile |
| `cards_data.csv` | 6,146 records | Card brand, type, credit limit, chip status, risk flags |
| `transactions_data.csv` | 13M+ records | Transaction date, amount, merchant, channel, error codes |
| `mcc_codes.json` | 100+ codes | Merchant Category Code descriptions |

> **Note:** Analysis was conducted on a representative one million row random sample drawn across the full 2010 to 2019 date range. The same pipeline scales directly to the full dataset on a cloud or database environment.

---

## 3. At a Glance

| Metric | Value |
|--------|-------|
| Transactions Analysed | 1M+ across 2010 to 2019 |
| Unique Customers | 2,000 — fully profiled and segmented |
| Online Channel Error Rate | 2.2% — highest of all three channels |
| Top Error Type Share | 70%+ — Insufficient Balance dominates |
| Top Merchant Revenue | $7.3M — Service Stations lead by volume |
| Top Customer Segment Spend | $45M — Lower-Mid income band |
| Top Card Brand by Volume | Mastercard at 53.8% |
| Daily Peak Window | 7am to 4pm — 90,000+ transactions per hour |

---

## 4. Findings & Recommendations

---

### Finding 01 — Online Channel Has the Worst Error Rate and the Highest Transaction Value

In-Store Swipe accounts for the largest transaction count at nearly 700,000 transactions. In-Store Chip follows at approximately 500,000. Online is the smallest channel by volume at roughly 150,000 transactions. However Online carries an error rate of 2.2% — materially higher than In-Store Chip at 1.5% and In-Store Swipe at 1.4%. Critically, Online also carries the highest average ticket value at approximately $58 per transaction versus $52 to $53 for in-store channels. This combination of high error rate and high transaction value makes the Online channel the most expensive problem on the platform.

**Recommendation:** Online payment gateway reliability should be the single highest priority technical investment. A 1% reduction in Online error rate — bringing it in line with In-Store Swipe — would recover more lost revenue per fix than equivalent improvements in any other channel. A dedicated gateway review should be initiated immediately alongside real-time error rate monitoring for the Online channel specifically.

---

### Finding 02 — Insufficient Balance Accounts for Over 70% of All Errors and $1M in Affected Value

Insufficient Balance is the dominant error type by a significant margin — approximately 13,000 occurrences accounting for over $1 million in affected transaction value. Bad PIN is a distant second at around 3,000 occurrences and Technical Glitch third at approximately 2,800. The remaining error types — Bad Card Number, Bad CVV, Bad Expiration, Bad Zipcode — are minor in comparison. Insufficient Balance is a customer-side issue. Technical Glitch is fully within the business control to resolve.

**Recommendation:** Two separate workstreams are required. First, Technical Glitch errors should be prioritised for engineering resolution — these are platform failures entirely within the business control. Second, Insufficient Balance errors require a customer-facing product response: real-time balance alerts before transaction submission and soft decline messaging that guides customers toward resolution rather than abandonment would materially reduce this error category over time.

---

### Finding 03 — Service Stations Lead Revenue While Grocery Stores Lead Transaction Frequency

Service Stations generate the highest total merchant category volume at approximately $7.3M, followed by Miscellaneous Food Stores at $6M and Money Transfer at $5.3M. However by transaction count, Grocery Stores and Supermarkets lead at approximately 160,000 transactions — ahead of even Service Stations at 150,000. Money Transfer stands out as high value with relatively low frequency — indicating very large individual transaction amounts in this category.

**Recommendation:** Money Transfer should receive dedicated fraud monitoring given the large amounts per transaction. Service Stations being the largest revenue category means any error rate improvement here has the highest direct revenue impact of any merchant-level fix. Both categories warrant category-specific monitoring thresholds rather than platform-wide averages.

---

### Finding 04 — Lower-Mid Income Band Drives $45M in Spend — Three Times the Next Highest Segment

The Lower-Mid income band dominates total spend at approximately $45M — more than three times the Mid band at $13M and five times the Low band at $9M. Upper-Mid and High income bands contribute negligibly at $3.5M and under $1M respectively. On the age dimension, the 46-55 group is the most active for both Male and Female customers, followed by 65+ and 36-45. The 18-25 segment is the least active by a wide margin across both genders.

**Recommendation:** The Lower-Mid income, 46-55 age profile is clearly the platform's core revenue-generating customer. All retention, loyalty, and product prioritisation decisions should be anchored around this segment. The 18-25 segment represents a significant long-term growth opportunity — targeted onboarding and low-barrier entry products designed for younger customers could materially expand the revenue base over the next three to five years.

---

### Finding 05 — Credit Cards Carry 2.5x the Average Transaction Value of Prepaid Debit Cards

Mastercard accounts for 53.8% of total transaction volume, followed by Visa at 38%, with Discover and Amex making up the remaining 8.2%. Error rates are largely consistent across all card brands and types at 1.4% to 1.6% — confirming that the error problem sits in the platform infrastructure rather than any specific card network integration. Credit card types average $65 to $70 per transaction. Debit cards average $50 to $55. Prepaid Debit cards average only $25 to $28.

**Recommendation:** The uniform error rate across all card brands rules out card-network specific fixes and confirms the remediation effort should focus on platform infrastructure. The significant value gap between Credit and Prepaid Debit transactions suggests Credit card customers generate materially more revenue per interaction — reliability investments that disproportionately benefit Credit card transactions will deliver the highest return.

---

### Finding 06 — Transaction Volume Peaks Sharply Between 7am and 4pm — Day of Week Shows No Variation

The hourly profile shows a clear ramp-up beginning at 6am, reaching peak volume between 10am and 12pm at approximately 90,000 to 95,000 transactions per hour. Volume remains elevated through the afternoon until 4pm when a sharp drop occurs. The overnight baseline from midnight to 5am holds at approximately 10,000 to 15,000 transactions per hour. The day-of-week analysis shows virtually identical volume across all seven days at approximately $10M per day — with no meaningful weekend versus weekday variation.

**Recommendation:** Operational staffing, fraud monitoring sensitivity, and incident response capacity should all be calibrated to the 7am to 4pm peak window. Any planned system maintenance should be scheduled in the midnight to 5am window when the risk of customer impact is lowest. Day-of-week based marketing campaigns are unlikely to produce differential results — timing efforts by hour of day will be significantly more effective.

---

## 5. Deliverables

| Deliverable | Format |
|-------------|--------|
| Data Quality Audit | Structured report inside `01_data_quality.ipynb` |
| Cleaned Master Dataset | CSV — 1M+ rows, 30+ columns, all three sources joined |
| SQL Cleaning Scripts | `01_cleaning_logic.sql` — all transformation logic in pure SQL |
| SQL KPI Scripts | `02_kpi_aggregations.sql` — all KPI queries in pure SQL |
| KPI Analysis Notebook | `02_analysis_kpis.ipynb` — 8 modules with inline charts |
| Dashboard Chart Exports | Six PNG files in `dashboard/` folder |
| Executive Case Study | This document and `docs/case_study.docx` |

---

## 6. Technology Stack

| Tool | Purpose |
|------|---------|
| Python / Pandas | Data cleaning and transformation |
| DuckDB | SQL queries directly on dataframes and CSV files |
| Matplotlib / Seaborn | Charts and visualisations |
| Jupyter Notebook | Analysis and client presentation |
| Power BI | Interactive dashboard |
| GitHub | Version control and portfolio |

---

## About Datawell Consultancy

We help fintech, servicing, and healthcare businesses organise their data, build reliable dashboards, and make better decisions.

datawellconsultants@gmail.com
datawellconsultancy.com

---

*Data used in this project is sourced from public datasets for portfolio demonstration purposes. All client references are illustrative.*

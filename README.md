# Financial Transaction Analytics
### Datawell Consultancy

---

## Business Problem

A mid-size fintech company operated three disconnected data systems — customer profiles,
card records, and transaction logs — none of which had ever been formally audited or
connected. The business had no reliable way to measure its own performance and could
not answer basic operational questions:

- What is our daily transaction volume and error rate?
- Which customer segments drive the most revenue?
- Which merchant categories carry the highest transaction value?
- Where are errors concentrated and what is their business impact?

**Our engagement:** Profile, clean, and connect all three data sources — then build a
unified analytics layer that answers these business questions with confidence.

---

## Dataset

| File | Records | Description |
|------|---------|-------------|
| `users_data.csv` | 2,000 customers | Demographics, income, credit score, debt |
| `cards_data.csv` | 6,146 cards | Card brand, type, credit limit, chip status |
| `transactions_data.csv` | 13M+ transactions | Date, amount, merchant, channel, errors |
| `mcc_codes.json` | 100+ categories | Merchant category code descriptions |

**Date Range:** 2010 — 2019

**Note:** Analysis uses a representative 1 million row random sample of the transactions
dataset. In a live client engagement the full dataset would be processed on a cloud
or database environment using the same pipeline.

---

## Key Findings

| Area | Finding |
|------|---------|
| Channel Errors | Online channel carries the highest error rate at 2.2% despite having the highest average transaction value at $58 |
| Top Error | Insufficient Balance accounts for over 70% of all transaction errors and over $1M in affected transaction value |
| Merchant Volume | Service Stations lead total volume at $7.3M — Grocery Stores lead transaction count at 160,000 |
| Money Transfer | Third highest category by volume at $5.3M with far fewer transactions — indicating very high average ticket size |
| Customer Segment | Lower-Mid income band drives $45M in spend — more than three times the next highest segment |
| Peak Age Group | 46-55 age group is the most active for both Male and Female customers |
| Card Volume | Mastercard accounts for 53.8% of total volume — Credit cards average $65-70 per transaction vs $25-28 for Prepaid Debit |
| Timing | Peak volume between 7am and 4pm — day of week shows no meaningful variation across all seven days |

---

## Project Structure

```
fintech-transaction-analytics/
├── data/
│   ├── raw/                        <- Original unmodified source files
│   │   ├── users_data.csv
│   │   ├── cards_data.csv
│   │   ├── transactions_data.csv
│   │   └── mcc_codes.json
│   └── cleaned/                    <- Output of cleaning pipeline
│       ├── users_cleaned.csv
│       ├── cards_cleaned.csv
│       ├── transactions_cleaned.csv
│       ├── master_dataset.csv      <- Unified joined table
│       └── kpi_*.csv               <- All KPI output tables
├── notebooks/
│   ├── 01_data_quality.ipynb       <- Phase 1: Audit, clean, join
│   └── 02_analysis_kpis.ipynb      <- Phase 2: KPI calculations & charts
├── sql/
│   ├── 01_cleaning_logic.sql       <- All cleaning transformations in SQL
│   └── 02_kpi_aggregations.sql     <- All KPI queries in pure SQL
├── dashboard/
│   └── *.png                       <- All chart exports
└── docs/
    └── case_study.docx             <- Client-ready case study
```

---

## How to Run

**Prerequisites:**
```bash
pip install pandas numpy matplotlib seaborn duckdb
```

**Run in order:**
```
1. notebooks/01_data_quality.ipynb
2. notebooks/02_analysis_kpis.ipynb
```

Each notebook exports its outputs to `data/cleaned/` and `dashboard/`.

---

## Technology Stack

| Tool | Purpose |
|------|---------|
| Python 3.11 | Core language |
| Pandas | Data manipulation and cleaning |
| DuckDB | SQL queries on dataframes and CSV files |
| Matplotlib / Seaborn | Charts and visualisations |
| Jupyter Notebook | Analysis and portfolio presentation |
| Power BI | Interactive dashboard |
| GitHub | Version control and portfolio |

---

## Deliverables

- Data quality audit across all three tables
- Cleaned and unified master dataset — 30+ columns
- 8 KPI analysis modules with professional charts
- SQL scripts for all cleaning and aggregation logic
- Interactive Power BI dashboard
- Executive case study document

---

## About Datawell Consultancy

We help fintech, servicing, and healthcare businesses organise their data, build
reliable dashboards, and make better decisions.

datawellconsultants@gmail.com
datawellconsultancy.com

---

*Data used in this project is sourced from public datasets for portfolio demonstration
purposes. All client references are illustrative.*

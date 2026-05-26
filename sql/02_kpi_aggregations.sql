-- ============================================================
-- Datawell Consultancy
-- Project: Financial Transaction Analytics
-- File: 02_kpi_aggregations.sql
-- Purpose: Core KPI calculations on the master dataset
-- Note: Assumes master_dataset table is available.
--       In DuckDB: replace 'master' with read_csv_auto('data/cleaned/master_dataset.csv')
-- ============================================================


-- ─────────────────────────────────────────
-- KPI 1: Executive Summary
-- ─────────────────────────────────────────

SELECT
    COUNT(*)                                                        AS total_transactions,
    COUNT(DISTINCT user_id)                                         AS unique_customers,
    COUNT(DISTINCT merchant_id)                                     AS unique_merchants,
    ROUND(SUM(amount_abs), 2)                                       AS total_volume_usd,
    ROUND(AVG(amount_abs), 2)                                       AS avg_txn_value_usd,
    ROUND(MEDIAN(amount_abs), 2)                                    AS median_txn_value_usd,
    SUM(CASE WHEN has_error = 'True' THEN 1 ELSE 0 END)            AS error_transactions,
    ROUND(AVG(CASE WHEN has_error = 'True' THEN 1.0 ELSE 0 END)*100, 2) AS error_rate_pct,
    SUM(CASE WHEN is_reversal = 'True' THEN 1 ELSE 0 END)          AS total_reversals,
    SUM(CASE WHEN is_online = 'True' THEN 1 ELSE 0 END)            AS online_transactions
FROM master;


-- ─────────────────────────────────────────
-- KPI 2: Yearly Trend
-- ─────────────────────────────────────────

SELECT
    txn_year,
    COUNT(*)                                                        AS total_txns,
    ROUND(SUM(amount_abs), 0)                                       AS total_volume,
    ROUND(AVG(amount_abs), 2)                                       AS avg_txn_value,
    SUM(CASE WHEN has_error = 'True' THEN 1 ELSE 0 END)            AS error_count,
    ROUND(AVG(CASE WHEN has_error = 'True' THEN 1.0 ELSE 0 END)*100, 2) AS error_rate_pct
FROM master
GROUP BY txn_year
ORDER BY txn_year;


-- ─────────────────────────────────────────
-- KPI 3: Channel Performance
-- ─────────────────────────────────────────

SELECT
    channel,
    COUNT(*)                                                        AS txn_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)             AS txn_share_pct,
    ROUND(SUM(amount_abs), 2)                                       AS total_volume,
    ROUND(AVG(amount_abs), 2)                                       AS avg_txn_value,
    ROUND(AVG(CASE WHEN has_error = 'True' THEN 1.0 ELSE 0 END)*100, 2) AS error_rate_pct
FROM master
GROUP BY channel
ORDER BY txn_count DESC;


-- ─────────────────────────────────────────
-- KPI 4: Error Analysis
-- ─────────────────────────────────────────

SELECT
    error_type,
    COUNT(*)                                                        AS occurrences,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)             AS share_pct,
    ROUND(SUM(amount_abs), 2)                                       AS total_amount_affected,
    ROUND(AVG(amount_abs), 2)                                       AS avg_amount_affected
FROM master
GROUP BY error_type
ORDER BY occurrences DESC;


-- ─────────────────────────────────────────
-- KPI 5: Top Merchant Categories
-- ─────────────────────────────────────────

SELECT
    merchant_category,
    COUNT(*)                                                        AS txn_count,
    ROUND(SUM(amount_abs), 2)                                       AS total_volume,
    ROUND(AVG(amount_abs), 2)                                       AS avg_txn_value,
    ROUND(AVG(CASE WHEN has_error = 'True' THEN 1.0 ELSE 0 END)*100, 2) AS error_rate_pct
FROM master
GROUP BY merchant_category
ORDER BY total_volume DESC
LIMIT 15;


-- ─────────────────────────────────────────
-- KPI 6: Customer Segment Analysis
-- ─────────────────────────────────────────

SELECT
    income_band,
    credit_tier,
    gender,
    age_group,
    COUNT(DISTINCT user_id)                                         AS unique_customers,
    COUNT(*)                                                        AS txn_count,
    ROUND(SUM(amount_abs), 2)                                       AS total_spend,
    ROUND(AVG(amount_abs), 2)                                       AS avg_txn_value
FROM master
WHERE income_band IS NOT NULL
AND   credit_tier IS NOT NULL
GROUP BY income_band, credit_tier, gender, age_group
ORDER BY total_spend DESC;


-- ─────────────────────────────────────────
-- KPI 7: Card Performance
-- ─────────────────────────────────────────

SELECT
    card_brand,
    card_type,
    COUNT(*)                                                        AS txn_count,
    ROUND(SUM(amount_abs), 2)                                       AS total_volume,
    ROUND(AVG(amount_abs), 2)                                       AS avg_txn_value,
    ROUND(AVG(CASE WHEN has_error = 'True' THEN 1.0 ELSE 0 END)*100, 2) AS error_rate_pct,
    SUM(CASE WHEN is_high_risk = 'True' THEN 1 ELSE 0 END)        AS high_risk_transactions
FROM master
WHERE card_brand IS NOT NULL
GROUP BY card_brand, card_type
ORDER BY total_volume DESC;


-- ─────────────────────────────────────────
-- KPI 8: Daily Monitoring Table
-- (Used for anomaly detection)
-- ─────────────────────────────────────────

SELECT
    txn_date,
    COUNT(*)                                                        AS txn_count,
    ROUND(SUM(amount_abs), 2)                                       AS total_volume,
    ROUND(AVG(amount_abs), 2)                                       AS avg_txn_value,
    SUM(CASE WHEN has_error = 'True' THEN 1 ELSE 0 END)            AS error_count,
    ROUND(AVG(CASE WHEN has_error = 'True' THEN 1.0 ELSE 0 END)*100, 4) AS error_rate_pct,
    SUM(CASE WHEN is_reversal = 'True' THEN 1 ELSE 0 END)          AS reversal_count,
    SUM(CASE WHEN is_online = 'True' THEN 1 ELSE 0 END)            AS online_count
FROM master
GROUP BY txn_date
ORDER BY txn_date;

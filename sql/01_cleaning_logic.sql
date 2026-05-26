-- ============================================================
-- Datawell Consultancy
-- Project: Financial Transaction Analytics
-- File: 01_cleaning_logic.sql
-- Purpose: Data cleaning transformations for all three tables
-- Note: These queries use DuckDB syntax and reference CSV files
--       directly. In a database environment, replace file paths
--       with actual table names.
-- ============================================================

-- ─────────────────────────────────────────
-- USERS TABLE — Cleaning Logic
-- ─────────────────────────────────────────

SELECT
    id,
    current_age,
    retirement_age,
    birth_year,
    birth_month,
    gender,
    address,
    latitude,
    longitude,

    -- Remove $ and commas from currency fields
    CAST(REPLACE(REPLACE(per_capita_income, '$', ''), ',', '') AS DOUBLE) AS per_capita_income,
    CAST(REPLACE(REPLACE(yearly_income, '$', ''), ',', '') AS DOUBLE)     AS yearly_income,
    CAST(REPLACE(REPLACE(total_debt, '$', ''), ',', '') AS DOUBLE)        AS total_debt,

    credit_score,
    num_credit_cards,

    -- Derived: Age group segmentation
    CASE
        WHEN current_age BETWEEN 0  AND 25  THEN '18-25'
        WHEN current_age BETWEEN 26 AND 35  THEN '26-35'
        WHEN current_age BETWEEN 36 AND 45  THEN '36-45'
        WHEN current_age BETWEEN 46 AND 55  THEN '46-55'
        WHEN current_age BETWEEN 56 AND 65  THEN '56-65'
        ELSE '65+'
    END AS age_group,

    -- Derived: Credit score tier
    CASE
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score < 670 THEN 'Fair'
        WHEN credit_score < 740 THEN 'Good'
        WHEN credit_score < 800 THEN 'Very Good'
        ELSE 'Exceptional'
    END AS credit_tier,

    -- Derived: Debt to income ratio
    ROUND(
        CAST(REPLACE(REPLACE(total_debt, '$', ''), ',', '') AS DOUBLE) /
        NULLIF(CAST(REPLACE(REPLACE(yearly_income, '$', ''), ',', '') AS DOUBLE), 0),
        2
    ) AS debt_to_income_ratio,

    -- Derived: Years to retirement
    retirement_age - current_age AS years_to_retirement

FROM read_csv_auto('data/raw/users_data.csv')
WHERE current_age >= 18          -- Remove invalid minor records
AND   credit_score BETWEEN 300 AND 850;  -- Valid credit score range


-- ─────────────────────────────────────────
-- CARDS TABLE — Cleaning Logic
-- ─────────────────────────────────────────

SELECT
    id,
    client_id,
    card_brand,
    card_type,
    card_number,
    expires,
    cvv,
    has_chip,
    num_cards_issued,
    year_pin_last_changed,
    card_on_dark_web,

    -- Remove $ and commas from credit limit
    CAST(REPLACE(REPLACE(credit_limit, '$', ''), ',', '') AS DOUBLE) AS credit_limit,

    -- Derived: Is card on dark web (risk flag)
    CASE WHEN card_on_dark_web = 'Yes' THEN TRUE ELSE FALSE END AS is_high_risk,

    -- Derived: Credit limit tier
    CASE
        WHEN CAST(REPLACE(REPLACE(credit_limit, '$', ''), ',', '') AS DOUBLE) < 5000    THEN 'Very Low'
        WHEN CAST(REPLACE(REPLACE(credit_limit, '$', ''), ',', '') AS DOUBLE) < 15000   THEN 'Low'
        WHEN CAST(REPLACE(REPLACE(credit_limit, '$', ''), ',', '') AS DOUBLE) < 30000   THEN 'Mid'
        WHEN CAST(REPLACE(REPLACE(credit_limit, '$', ''), ',', '') AS DOUBLE) < 60000   THEN 'High'
        ELSE 'Premium'
    END AS limit_tier

FROM read_csv_auto('data/raw/cards_data.csv');


-- ─────────────────────────────────────────
-- TRANSACTIONS TABLE — Cleaning Logic
-- ─────────────────────────────────────────

SELECT
    id,
    CAST(date AS TIMESTAMP)                                                 AS txn_datetime,
    CAST(date AS DATE)                                                      AS txn_date,
    EXTRACT(YEAR  FROM CAST(date AS TIMESTAMP))                             AS txn_year,
    EXTRACT(MONTH FROM CAST(date AS TIMESTAMP))                             AS txn_month,
    EXTRACT(DAY   FROM CAST(date AS TIMESTAMP))                             AS txn_day,
    EXTRACT(HOUR  FROM CAST(date AS TIMESTAMP))                             AS txn_hour,
    client_id,
    card_id,

    -- Remove $ sign and cast amount to float
    CAST(REPLACE(REPLACE(amount, '$', ''), ',', '') AS DOUBLE)             AS amount,
    ABS(CAST(REPLACE(REPLACE(amount, '$', ''), ',', '') AS DOUBLE))        AS amount_abs,

    -- Flag reversals (negative amounts)
    CASE WHEN CAST(REPLACE(REPLACE(amount, '$', ''), ',', '') AS DOUBLE) < 0
         THEN TRUE ELSE FALSE END                                           AS is_reversal,

    -- Standardise channel
    CASE use_chip
        WHEN 'Swipe Transaction'  THEN 'In-Store Swipe'
        WHEN 'Online Transaction' THEN 'Online'
        WHEN 'Chip Transaction'   THEN 'In-Store Chip'
        ELSE 'Other'
    END                                                                     AS channel,

    -- Is online transaction?
    CASE WHEN merchant_city = 'ONLINE' THEN TRUE ELSE FALSE END            AS is_online,

    merchant_id,
    merchant_city,
    merchant_state,
    zip,
    mcc,

    -- Flag transactions with errors
    CASE WHEN errors IS NOT NULL THEN TRUE ELSE FALSE END                   AS has_error,
    COALESCE(errors, 'No Error')                                           AS error_type

FROM read_csv_auto('data/raw/transactions_data.csv');

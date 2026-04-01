-- ==============================
-- ANALYSIS QUERIES 
-- ==============================

-- 1. Preview Data(Quick data check)

CREATE OR REPLACE VIEW  quick_data_check AS
SELECT * FROM clean_transactions LIMIT 10;

SELECT * FROM quick_data_check;

-- 2. Count Total Records(Dataset size)

CREATE OR REPLACE VIEW dataset_size_check AS
SELECT COUNT(*) AS total_records FROM clean_transactions;

SELECT * FROM dataset_size_check; 

-- 3. Check Class Distribution(Fraud imbalance)

CREATE OR REPLACE VIEW check_class_distribution AS
SELECT class, COUNT(*) AS total
FROM clean_transactions
GROUP BY class;

SELECT * FROM check_class_distribution;

-- 4. Get Fraud Transactions(Extract fraud data)

CREATE OR REPLACE VIEW get_fraud_transactions AS
SELECT *
FROM clean_transactions
WHERE class = 1;

SELECT * FROM get_fraud_transactions;

-- 5. Get Legitimate Transactions(Extract normal data)

CREATE OR REPLACE VIEW get_legitimate_transactions AS
SELECT *
FROM clean_transactions
WHERE class = 0;

SELECT * FROM get_legitimate_transactions;

-- 6. Average Transaction Amount(Overall spending trend)

CREATE OR REPLACE VIEW average_transaction_amount AS
SELECT AVG(amount) AS avg_amount
FROM clean_transactions;

SELECT * FROM average_transaction_amount;

-- 7. Max Transaction Amount(Detect extreme values)

CREATE OR REPLACE VIEW max_transaction_amount AS
SELECT MAX(amount) AS max_amount
FROM clean_transactions;

SELECT * FROM max_transaction_amount;

-- 8. Min Transaction Amount(Lower bound check)

CREATE OR REPLACE VIEW min_transaction_amount AS
SELECT MIN(amount) AS min_amount
FROM clean_transactions;

SELECT * FROM min_transaction_amount;

-- 9. Average Amount by Class(Compare fraud vs normal)

CREATE OR REPLACE VIEW average_amount_by_class AS
SELECT class, AVG(amount) AS avg_amount
FROM clean_transactions
GROUP BY class;

SELECT * FROM average_amount_by_class;

-- 10. Count Transactions Above Threshold(High-value transactions)
CREATE OR REPLACE VIEW transactions_above_threshold AS
SELECT COUNT(*)as Total_high_value
FROM clean_transactions
WHERE amount > 2500;

SELECT * FROM transactions_above_threshold;
-- 
'''
-- Update Time in Hours 
UPDATE clean_transactions
SET time_hours = time_hours / 3600;'''

-- 11. Create Fraud View(Reusable fraud dataset)

CREATE OR REPLACE VIEW v_fraud_transactions AS
SELECT *
FROM clean_transactions
WHERE class = 1;

SELECT * FROM v_fraud_transactions;

-- 12. Top 10 Highest Transactions(Detect anomalies)

CREATE OR REPLACE VIEW top_10_highest_transactions AS
SELECT *
FROM clean_transactions
ORDER BY amount DESC
LIMIT 10;

SELECT * FROM top_10_highest_transactions;


-- 13. Count Transactions Per Hour(Time-based analysis)

'''SELECT time_hours AS hour, COUNT(*) AS total
FROM clean_transactions
GROUP BY hour
ORDER BY hour;'''

CREATE OR REPLACE VIEW transaction_time_dayhours AS
SELECT 
    EXTRACT(HOUR FROM time_hours::timestamp) AS hour,
    COUNT(*) AS total_transactions,
    CASE
        WHEN EXTRACT(HOUR FROM time_hours::timestamp) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM time_hours::timestamp) BETWEEN 12 AND 13 THEN 'Noon'
        WHEN EXTRACT(HOUR FROM time_hours::timestamp) BETWEEN 14 AND 16 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM time_hours::timestamp) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS time_period
FROM clean_transactions
GROUP BY hour
ORDER BY hour;

SELECT * FROM transaction_time_dayhours;

-- 14. Fraud Percentage(Fraud rate)

CREATE OR REPLACE VIEW fraud_percentage AS
SELECT 
    (COUNT(*) FILTER (WHERE class = 1) * 100.0 / COUNT(*)) AS fraud_percentage
FROM clean_transactions;

SELECT * FROM fraud_percentage;

-- 15. Top 10 Fraud Amounts
CREATE OR REPLACE VIEW top_fraud_amount AS
SELECT amount, class, time_hours
FROM clean_transactions
WHERE class = 1
ORDER BY amount DESC
LIMIT 10;

SELECT * FROM top_fraud_amount;

-- 16. Suspicious Small Transactions (Fraud)
CREATE OR REPLACE VIEW suspicious_small_transactions AS
SELECT amount, class, time_hours
FROM clean_transactions
WHERE class = 1 AND amount < 10;

SELECT * FROM suspicious_small_transactions;

-- 17. Compare Fraud vs Normal Count by Hour
CREATE OR REPLACE VIEW fraud_vs_normal_hours_count AS
SELECT 
    EXTRACT(HOUR FROM time_hours ::timestamp) AS hour,
    COUNT(*) FILTER (WHERE class = 1) AS Fraudulent,
    COUNT(*) FILTER (WHERE class = 0) AS Legitimate
FROM clean_transactions
GROUP BY hour
ORDER BY hour;

SELECT * FROM fraud_vs_normal_hours_count;

-- 18. Fraud Ratio by Amount Buckets
CREATE OR REPLACE VIEW fraud_ratio_by_amount_buckets AS
SELECT 
    WIDTH_BUCKET(amount, 0, 2000, 5) AS bucket,
    COUNT(*) FILTER (WHERE class = 1) AS fraud_count
FROM clean_transactions
GROUP BY bucket;

SELECT * FROM fraud_ratio_by_amount_buckets;

-- 19. Peak Fraud Hour

CREATE OR REPLACE VIEW peak_fraud_hour AS
SELECT 
    EXTRACT(HOUR FROM time_hours ::timestamp) AS hour,
    COUNT(*) FILTER (WHERE class = 1) AS fraud_count
FROM clean_transactions
GROUP BY hour
ORDER BY fraud_count DESC
LIMIT 5;

SELECT * FROM peak_fraud_hour;

-- 20. Transactions with High Risk Pattern

CREATE OR REPLACE VIEW transactions_with_high_risk_pattern AS
SELECT amount, time_hours
FROM clean_transactions
WHERE class = 1
AND amount > (SELECT AVG(amount) FROM clean_transactions)
AND EXTRACT(HOUR FROM time_hours ::timestamp) BETWEEN 9 AND 23;

SELECT * FROM transactions_with_high_risk_pattern;

-- 21. Transactions Per Hour 
CREATE OR REPLACE VIEW transactions_per_hour AS
SELECT 
    DATE_TRUNC('hour', time_hours ::timestamp) AS hour,
    COUNT(*) AS total
FROM clean_transactions
GROUP BY hour
ORDER BY hour;

SELECT * FROM transactions_per_hour;


--FIXING ERROR

'''DROP VIEW IF EXISTS "quick_data_check" CASCADE;
DROP VIEW IF EXISTS "dataset_size_check" CASCADE;
DROP VIEW IF EXISTS "check_class_distribution" CASCADE;
DROP VIEW IF EXISTS "get_fraud_transactions" CASCADE;
DROP VIEW IF EXISTS "get_legitimate_transactions" CASCADE;
DROP VIEW IF EXISTS "average_transaction_amount" CASCADE;
DROP VIEW IF EXISTS "max_transaction_amount" CASCADE;
DROP VIEW IF EXISTS "min_transaction_amount" CASCADE;
DROP VIEW IF EXISTS "average_amount_by_class" CASCADE;
DROP VIEW IF EXISTS "transactions_above_threshold" CASCADE;
DROP VIEW IF EXISTS "top_10_highest_transactions" CASCADE;
DROP VIEW IF EXISTS "v_fraud_transactions" CASCADE;
DROP VIEW IF EXISTS "transaction_time_dayhours" CASCADE;
DROP VIEW IF EXISTS "fraud_percentage" CASCADE;
DROP VIEW IF EXISTS "top_fraud_amount" CASCADE;
DROP VIEW IF EXISTS "suspicious_small_transactions" CASCADE;
DROP VIEW IF EXISTS "fraud_vs_normal_hours_count" CASCADE;
DROP VIEW IF EXISTS "fraud_ratio_by_amount_buckets" CASCADE;
DROP VIEW IF EXISTS "peak_fraud_hour" CASCADE;
DROP VIEW IF EXISTS "transactions_with_high_risk_pattern" CASCADE;
DROP VIEW IF EXISTS "transactions_per_hour" CASCADE;'''
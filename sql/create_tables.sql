
-- CREATE DATABASE TABLE CREDITCARD

CREATE TABLE IF NOT EXISTS creditcard (
    time DOUBLE PRECISION,
    v1 DOUBLE PRECISION, v2 DOUBLE PRECISION, v3 DOUBLE PRECISION, v4 DOUBLE PRECISION, v5 DOUBLE PRECISION,
    v6 DOUBLE PRECISION, v7 DOUBLE PRECISION, v8 DOUBLE PRECISION, v9 DOUBLE PRECISION, v10 DOUBLE PRECISION,
    v11 DOUBLE PRECISION, v12 DOUBLE PRECISION, v13 DOUBLE PRECISION, v14 DOUBLE PRECISION, v15 DOUBLE PRECISION,
    v16 DOUBLE PRECISION, v17 DOUBLE PRECISION, v18 DOUBLE PRECISION, v19 DOUBLE PRECISION, v20 DOUBLE PRECISION,
    v21 DOUBLE PRECISION, v22 DOUBLE PRECISION, v23 DOUBLE PRECISION, v24 DOUBLE PRECISION, v25 DOUBLE PRECISION,
    v26 DOUBLE PRECISION, v27 DOUBLE PRECISION, v28 DOUBLE PRECISION,
    amount DOUBLE PRECISION,
    class INTEGER
);

-- COPY LOAD THE DATA IN MY TABLE

COPY creditcard
FROM 'E:/INFYNTREK_DA/Transactional Fraud Detection/data/creditcard.csv'
DELIMITER ','
CSV HEADER;

-- COUNT TOTAL NUMBER OF ROWS IN MY DATASET
SELECT COUNT(*) AS total_rows FROM creditcard;

-- VIEW MY TABLE
SELECT * FROM creditcard LIMIT 5;

-- CHECKING COLUMN NAME AND DATA TYPE
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'creditcard';


-- CHECKING MISSING VALUES
SELECT 
    COUNT(*) FILTER (WHERE time IS NULL) AS missing_time,
    COUNT(*) FILTER (WHERE amount IS NULL) AS missing_amount,
    COUNT(*) FILTER (WHERE class IS NULL) AS missing_class
FROM creditcard;


-- CHECKING MIN,MAX,AVG,STD AMOUNT VALUES
SELECT 
    AVG(amount) AS avg_amount,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    STDDEV(amount) AS std_amount
FROM creditcard;


--Check if Duplicates Exist
SELECT 
    COUNT(*) AS total_rows,
    (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM creditcard) AS t) AS unique_rows
FROM creditcard;


SELECT *, COUNT(*)
FROM creditcard
GROUP BY time, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10,
         v11, v12, v13, v14, v15, v16, v17, v18, v19, v20,
         v21, v22, v23, v24, v25, v26, v27, v28, amount, class
HAVING COUNT(*) > 1;

DELETE FROM creditcard a
USING creditcard b
WHERE a.ctid < b.ctid
AND a.time = b.time
AND a.v1 = b.v1
AND a.v2 = b.v2
AND a.v3 = b.v3
AND a.v4 = b.v4
AND a.v5 = b.v5
AND a.v6 = b.v6
AND a.v7 = b.v7
AND a.v8 = b.v8
AND a.v9 = b.v9
AND a.v10 = b.v10
AND a.v11 = b.v11
AND a.v12 = b.v12
AND a.v13 = b.v13
AND a.v14 = b.v14
AND a.v15 = b.v15
AND a.v16 = b.v16
AND a.v17 = b.v17
AND a.v18 = b.v18
AND a.v19 = b.v19
AND a.v20 = b.v20
AND a.v21 = b.v21
AND a.v22 = b.v22
AND a.v23 = b.v23
AND a.v24 = b.v24
AND a.v25 = b.v25
AND a.v26 = b.v26
AND a.v27 = b.v27
AND a.v28 = b.v28
AND a.amount = b.amount
AND a.class = b.class;

SELECT 
    COUNT(*) AS total_rows,
    (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM creditcard) AS t) AS unique_rows;

UPDATE creditcard
SET amount = (SELECT AVG(amount) FROM creditcard)
WHERE amount IS NULL;

UPDATE creditcard
SET amount = ABS(amount)
WHERE amount < 0;

SELECT 
    class,
    COUNT(*) AS count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM creditcard), 2) AS percentage
FROM creditcard
GROUP BY class;



drop table creditcard;

select * from clean_transactions;
select * from creditcard;


DROP TABLE IF EXISTS clean_transactions CASCADE;

CREATE TABLE IF NOT EXISTS clean_transactions (
    v1 DOUBLE PRECISION, v2 DOUBLE PRECISION, v3 DOUBLE PRECISION, v4 DOUBLE PRECISION, v5 DOUBLE PRECISION,
    v6 DOUBLE PRECISION, v7 DOUBLE PRECISION, v8 DOUBLE PRECISION, v9 DOUBLE PRECISION, v10 DOUBLE PRECISION,
    v11 DOUBLE PRECISION, v12 DOUBLE PRECISION, v13 DOUBLE PRECISION, v14 DOUBLE PRECISION, v15 DOUBLE PRECISION,
    v16 DOUBLE PRECISION, v17 DOUBLE PRECISION, v18 DOUBLE PRECISION, v19 DOUBLE PRECISION, v20 DOUBLE PRECISION,
    v21 DOUBLE PRECISION, v22 DOUBLE PRECISION, v23 DOUBLE PRECISION, v24 DOUBLE PRECISION, v25 DOUBLE PRECISION,
    v26 DOUBLE PRECISION, v27 DOUBLE PRECISION, v28 DOUBLE PRECISION,
    amount DOUBLE PRECISION,
    class INTEGER,
	time_hours TIMESTAMP
);


COPY clean_transactions 
FROM 'E:/INFYNTREK_DA/Transactional Fraud Detection/data/clean_transactions.csv'
DELIMITER ','
CSV HEADER;

select * from clean_transactions;


-- 4. Quick checks
SELECT COUNT(*) FROM clean_transactions;
SELECT * FROM clean_transactions LIMIT 5;

-- 5. Indexing (performance boost)
CREATE INDEX IF NOT EXISTS idx_clean_class ON clean_transactions(class);
CREATE INDEX IF NOT EXISTS idx_clean_amount ON clean_transactions(amount);
CREATE INDEX IF NOT EXISTS idx_clean_time ON clean_transactions(time_hours);
CREATE INDEX IF NOT EXISTS idx_class_amount ON clean_transactions(class, amount);

-- 6. Optimize
ANALYZE clean_transactions;

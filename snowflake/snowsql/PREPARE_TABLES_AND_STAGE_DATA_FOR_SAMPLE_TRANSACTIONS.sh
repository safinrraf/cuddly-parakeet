#!/bin/bash

snowsql -q "USE DATABASE MYTEST_DATABASE;
USE SCHEMA MYTEST_SCHEMA;

CREATE TABLE IF NOT EXISTS TRANSACTIONS (
    TRANSACTION_ID STRING,
    TRANSACTION_TIMESTAMP TIMESTAMP,
    CUSTOMER_ID INTEGER,
    AMOUNT NUMBER(30,2),
    TRANSACTION_TYPE STRING,
    CONSTRAINT TRANSACTIONS_PK PRIMARY KEY (TRANSACTION_ID)
)
CLUSTER BY (TRANSACTION_TIMESTAMP);
"

snowsql -q "PUT file://./test_data/transactions.csv @%TRANSACTIONS" --dbname MYTEST_DATABASE --schemaname MYTEST_SCHEMA


snowsql -q "USE DATABASE MYTEST_DATABASE;
USE SCHEMA MYTEST_SCHEMA;

COPY INTO TRANSACTIONS
PURGE = TRUE
FILE_FORMAT = (TYPE = CSV
SKIP_HEADER = 1
TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS'
FIELD_DELIMITER = ','
FIELD_OPTIONALLY_ENCLOSED_BY = '\"');
"
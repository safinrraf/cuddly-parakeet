#!/bin/bash

snowsql -q "USE DATABASE MYTEST_DATABASE;
USE SCHEMA MYTEST_SCHEMA;

-- create provider shipping data table
CREATE OR REPLACE TABLE MFG_SHIPPING (
  order_id NUMBER(38,0),
  ship_order_id NUMBER(38,0),
  status VARCHAR(60),
  lat FLOAT,
  lon FLOAT,
  duration NUMBER(38,0)
);

CREATE OR REPLACE TABLE MFG_ORDERS (
  order_id NUMBER(38,0),
  material_name VARCHAR(60),
  supplier_name VARCHAR(60),
  quantity NUMBER(38,0),
  cost FLOAT,
  process_supply_day NUMBER(38,0)
);

-- create consumer recovery data table
CREATE OR REPLACE TABLE MFG_SITE_RECOVERY (
  event_id NUMBER(38,0),
  recovery_weeks NUMBER(38,0),
  lat FLOAT,
  lon FLOAT
);
"

# loading shipping data into table stage
snowsql -q "PUT file://./test_data/shipping_data.csv @%MFG_SHIPPING" --dbname MYTEST_DATABASE --schemaname MYTEST_SCHEMA

# loading orders data into table stage
snowsql -q "PUT file://./test_data/order_data.csv @%MFG_ORDERS" --dbname MYTEST_DATABASE --schemaname MYTEST_SCHEMA

# loading site recovery data into table stage
snowsql -q "PUT file://./test_data/site_recovery_data.csv @%MFG_SITE_RECOVERY" --dbname MYTEST_DATABASE --schemaname MYTEST_SCHEMA

--Best Practice #4: Set Account Statement Timeouts
--Use the STATEMENT_QUEUED_TIMEOUT_IN_SECONDS and  STATEMENT_TIMEOUT_IN_SECONDS parameters to automatically
-- stop queries that are taking too long to execute, either due to a user error or a frozen cluster.
ALTER WAREHOUSE LOAD_WH
SET
    STATEMENT_TIMEOUT_IN_SECONDS = 3600;

SHOW PARAMETERS IN WAREHOUSE LOAD_WH;

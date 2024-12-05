-- Create a custom role for Terraform
CREATE ROLE terraform_role;

-- Grant necessary privileges to the role
-- Grant database creation privilege
GRANT CREATE DATABASE ON ACCOUNT TO ROLE terraform_role;

-- Grant warehouse creation privilege
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE terraform_role;

-- Grant schema and table management privileges (optional if needed)
GRANT CREATE SCHEMA ON DATABASE MOTIVATED_RABBIT TO ROLE terraform_role;

GRANT
CREATE TABLE ON SCHEMA MOTIVATED_RABBIT.BROCCOLI TO ROLE terraform_role;

GRANT
SELECT
    ON FUTURE TABLES IN schema MOTIVATED_RABBIT.BROCCOLI TO ROLE terraform_role;

GRANT ALL ON SCHEMA MOTIVATED_RABBIT.BROCCOLI TO ROLE terraform_role;

GRANT ALL ON FUTURE SCHEMAS IN DATABASE MOTIVATED_RABBIT TO ROLE terraform_role;

GRANT ALL ON FUTURE TABLES IN SCHEMA MOTIVATED_RABBIT.BROCCOLI TO ROLE terraform_role;

CREATE USER terraform_user PASSWORD = '...' LOGIN_NAME = 'terraform_user' DEFAULT_ROLE = 'terraform_role' MUST_CHANGE_PASSWORD = FALSE COMMENT = 'Dedicated user for Terraform integration';

GRANT ROLE terraform_role TO USER terraform_user;

ALTER USER terraform_user
SET
    RSA_PUBLIC_KEY = 'MIIBIjAN.....';

--Verify the user’s public key fingerprint
DESC USER terraform_user;

SELECT
    SUBSTR (
        (
            SELECT
                "value"
            FROM
                TABLE (RESULT_SCAN (LAST_QUERY_ID ()))
            WHERE
                "property" = 'RSA_PUBLIC_KEY_FP'
        ),
        LEN ('SHA256:') + 1
    );

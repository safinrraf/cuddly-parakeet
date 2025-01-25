CREATE ROLE terraform_role;

GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE terraform_role;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE terraform_role;
GRANT MONITOR USAGE ON ACCOUNT TO ROLE terraform_role; -- Optional: To monitor objects

-- Allow Terraform to create schemas in a specific database
GRANT USAGE ON DATABASE <database_name> TO ROLE terraform_role;
GRANT CREATE SCHEMA ON DATABASE <database_name> TO ROLE terraform_role;

-- Allow Terraform to manage objects within the schema
GRANT USAGE ON SCHEMA <database_name>.<schema_name> TO ROLE terraform_role;
GRANT CREATE TABLE ON SCHEMA <database_name>.<schema_name> TO ROLE terraform_role;
GRANT CREATE STAGE ON SCHEMA <database_name>.<schema_name> TO ROLE terraform_role;
GRANT CREATE FILE FORMAT ON SCHEMA <database_name>.<schema_name> TO ROLE terraform_role;
GRANT CREATE VIEW ON SCHEMA <database_name>.<schema_name> TO ROLE terraform_role;
GRANT CREATE SEQUENCE ON SCHEMA <database_name>.<schema_name> TO ROLE terraform_role;

--If Terraform will handle access control (grants), provide the MANAGE GRANTS privilege:
GRANT MANAGE GRANTS ON ACCOUNT TO ROLE terraform_role;

CREATE USER terraform_user
PASSWORD = '<secure_password>'
DEFAULT_ROLE = terraform_role
MUST_CHANGE_PASSWORD = FALSE;

GRANT ROLE terraform_role TO USER terraform_user;

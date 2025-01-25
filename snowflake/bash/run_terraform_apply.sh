#!/bin/bash

terraform plan -var "snowflake_user_name=$SNOWFLAKE_USER" \
-var "snowflake_user_password=$SNOWFLAKE_PASSWORD" \
-var "snowflake_account_name=$SNOWFLAKE_ACCOUNT" \
-var "snowflake_organization_name=$SNOWFLAKE_ORGANISATION_NAME="

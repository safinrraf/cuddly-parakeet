#!/bin/bash

#exec SELECT LOWER(current_organization_name() || '-' || current_account_name()) as YOUR_SNOWFLAKE_ACCOUNT;
#to get SNOWFLAKE_ACCOUNT value

export SNOWFLAKE_USER="terraform_user"
export SNOWFLAKE_AUTHENTICATOR=JWT
export SNOWFLAKE_PRIVATE_KEY=`cat ~/.ssh/rsa_key_snowflake_$SNOWFLAKE_ACCOUNT_terraform_user.p8`
export SNOWFLAKE_ACCOUNT="..."

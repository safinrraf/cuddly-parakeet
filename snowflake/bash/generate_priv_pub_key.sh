#!/bin/bash

cd ~/.ssh

#generate private key
openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out rsa_key_snowflake_fgulwhl_oz51801_terraform_user.p8

#generate pub key based on the private key
openssl rsa -in rsa_key_snowflake_fgulwhl_oz51801_terraform_user.p8 -pubout -out rsa_key_snowflake_fgulwhl_oz51801_terraform_user.pub

#veriyfy the fingerprint
openssl rsa -pubin -in rsa_key_snowflake_fgulwhl_oz51801_terraform_user.pub -outform DER | openssl dgst -sha256 -binary | openssl enc -base64

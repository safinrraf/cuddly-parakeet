# Specify required providers
terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
    }
  }
}

# Snowflake provider configuration
provider "snowflake" {
  role                   = "terraform_role"
  private_key_passphrase = "123"
}

# Create a new Snowflake table
resource "snowflake_table" "table1" {
  name     = "TABLE_1"
  database = "MOTIVATED_RABBIT"
  schema   = "BROCCOLI"
  column {
    name = "id"
    type = "INTEGER"
  }
  column {
    name = "name"
    type = "STRING"
  }
  column {
    name = "created_at"
    type = "TIMESTAMP_NTZ"
  }
}

resource "snowflake_table" "table2" {
  name     = "TABLE_2"
  database = "MOTIVATED_RABBIT"
  schema   = "BROCCOLI"
  column {
    name = "id"
    type = "INTEGER"
  }
  column {
    name = "description"
    type = "STRING"
  }
  column {
    name = "updated_at"
    type = "TIMESTAMP_NTZ"
  }
}

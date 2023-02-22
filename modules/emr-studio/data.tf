#========================================================
# Existing Networking Resources
#========================================================

data "aws_vpc" "main" {
  tags = {
    Name = "main"
  }
}

data "aws_security_group" "emr_engine_security_group" {
  name = "emr_engine_security_group"
}

data "aws_security_group" "emr_workspace_security_group" {
  name = "emr_workspace_security_group"
}

data "aws_subnet" "Private-1A" {
  filter {
    name   = "tag:Name"
    values = ["Private-1A"]
  }
}

data "aws_subnet" "Private-1B" {
  filter {
    name   = "tag:Name"
    values = ["Private-1B"]
  }
}

data "aws_subnet" "Private-1C" {
  filter {
    name   = "tag:Name"
    values = ["Private-1C"]
  }
}

#========================================================
# Existing SSO Resources
#========================================================

#Identify the Group, which we will Assign these Permissions To
data "aws_identitystore_group" "admins" {
  identity_store_id = var.identity_store_id
  filter {
    attribute_path  = "DisplayName"
    attribute_value = "admins"
  }
}

#Identify the Group, which we will Assign these Permissions To
data "aws_identitystore_group" "dataengineers" {
  identity_store_id = var.identity_store_id
  filter {
    attribute_path  = "DisplayName"
    attribute_value = "dataengineers"
  }
}
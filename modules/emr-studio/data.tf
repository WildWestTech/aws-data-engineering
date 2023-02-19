data "aws_security_group" "emr_engine_security_group" {
  name = "emr_engine_security_group"
}

data "aws_security_group" "emr_workspace_security_group" {
  name = "emr_workspace_security_group"
}

data "aws_vpc" "main" {
  tags = {
    Name = "main"
  }
}

data "aws_subnet" "Private-1A" {
  filter {
    name   = "tag:Name"
    values = ["Private-1C"]
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
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["main"]
  }
}

data "aws_subnet" "Private-1A" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "Private-1A"
  }
}

data "aws_subnet" "Private-1B" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "Private-1B"
  }
}

data "aws_subnet" "Private-1C" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "Private-1C"
  }
}
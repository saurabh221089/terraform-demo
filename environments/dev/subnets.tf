resource "aws_subnet" "dev_public_subnet1" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.dev_public_subnet1_cidr
  availability_zone = "eu-north-1a"

  tags = {
    Name = "dev_public_subnet1"
  }
}

resource "aws_subnet" "dev_public_subnet2" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.dev_public_subnet2_cidr
  availability_zone = "eu-north-1b"

  tags = {
    Name = "dev_public_subnet2"
  }
}

resource "aws_subnet" "dev_private_subnet1" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.dev_private_subnet1_cidr
  availability_zone = "eu-north-1a"

  tags = {
    Name = "dev_private_subnet1"
  }
}

resource "aws_subnet" "dev_private_subnet2" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.dev_private_subnet2_cidr
  availability_zone = "eu-north-1b"

  tags = {
    Name = "dev_private_subnet2"
  }
}

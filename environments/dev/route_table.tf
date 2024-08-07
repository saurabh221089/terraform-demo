resource "aws_route_table" "dev_public_route_tbl" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_public_route_tbl"
  }
}

resource "aws_route_table" "dev_private_route_tbl" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_private_route_tbl"
  }
}

resource "aws_route" "tf_public_route" {
  route_table_id         = aws_route_table.dev_public_route_tbl.id
  gateway_id             = aws_internet_gateway.dev_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "dev_public_subnet1_assn" {
  route_table_id = aws_route_table.dev_public_route_tbl.id
  subnet_id      = aws_subnet.dev_public_subnet1.id
}

resource "aws_route_table_association" "dev_public_subnet2_assn" {
  route_table_id = aws_route_table.dev_public_route_tbl.id
  subnet_id      = aws_subnet.dev_public_subnet2.id
}

resource "aws_route_table_association" "dev_private_subnet1_assn" {
  route_table_id = aws_route_table.dev_private_route_tbl.id
  subnet_id      = aws_subnet.dev_private_subnet1.id
}

resource "aws_route_table_association" "dev_private_subnet2_assn" {
  route_table_id = aws_route_table.dev_private_route_tbl.id
  subnet_id      = aws_subnet.dev_private_subnet2.id
}

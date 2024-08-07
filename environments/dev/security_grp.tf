resource "aws_security_group" "frontend_sec_grp" {
  vpc_id      = aws_vpc.dev_vpc.id
  description = "frontend_sec_grp"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow incoming traffic on Port 80"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow incoming SSH traffic"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_sec_grp" {
  vpc_id      = aws_vpc.dev_vpc.id
  description = "backend_sec_grp"

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow incoming SSH traffic"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
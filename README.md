# terraform-demo

## Workspaces

terraform workspace new dev
terraform workspace list
terraform workspace select dev

resource "aws_s3_bucket" "example" {
  bucket = "my-app-${terraform.workspace}"
  acl    = "private"
}
-------------------------------------------------
## Types of Provisioners

Local-exec: Executes a command on the machine running Terraform.
Remote-exec: Executes a command on the newly created resource.
```
resource "aws_instance" "example" {
  # ...

  provisioner "local-exec" {
    command = "echo 'New instance created' > instance_creation.txt"
  }
}
```

```
resource "aws_instance" "example" {
  # ...

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}
```
-------------------------------------------------
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filters {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
}
-------------------------------------------------
data "aws_instance" "nontf_instance" {
    instance_id = "i-044b2af955b1ae4e1"
}

output "nontf_instance_ip" {
    value = data.aws_instance.nontf_instance.public_ip
}
---------------------------------------------------
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "AppVPC"
  }
}

resource "aws_subnet" "app_subnet_1" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "AppSubnet1"
  }
}

resource "aws_subnet" "app_subnet_2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "AppSubnet2"
  }
}

resource "aws_security_group" "WebTrafficSG" {
  name        = "WebTrafficSG"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebTrafficSG"
  }
}

resource "aws_instance" "app_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.app_subnet_1.id
  security_groups = [aws_security_group.app_sg.name]

  tags = {
    Name = "AppInstance"
  }
}

resource "aws_db_instance" "app_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "appdb"
  username             = "admin"
  password             = "yourpassword"
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.app_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "AppDBInstance"
  }
}


variable "instance_type" {
  value = var.env == "prod" ? "t3.large" : "t3.micro"
}

---------------------------------------------------

$ terraform workspace list

lookup(var.ami, terraform.workspace)

variable "ami" {
	type = map
	default = {
		"dev" = "ami-xxxxxxx",
		"int" = "ami-yyyyyyyyy",
		"stage" = "ami-zzzzzzzz"
	}
}

module "payroll_app" {
    source = "../modules/payroll-app"
    app_region = lookup(var.region, terraform.workspace)
    ami = lookup(var.ami, terraform.workspace)
}
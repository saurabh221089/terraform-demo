# terraform-demo

## Implementation of Terrascan
```
docker pull tenable/terrascan:latest

  curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E "https://.+?_Linux_x86_64.tar.gz")" > terrascan.tar.gz
  tar -xf terrascan.tar.gz terrascan && rm terrascan.tar.gz
  sudo install terrascan /usr/local/bin && rm terrascan
  terrascan version

$ terrascan scan -t aws
$ terrascan scan -i terraform
$ terrascan scan -i k8s
$ terrascan scan -i helm
$ terrascan scan -i kustomize
$ terrascan scan -i docker (For scanning dockerfile in current dir)

$ terrascan scan -t aws -d ./terraform --severity high
```

## Working with ECR
#### DOCKER PUSH
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 112233445566.dkr.ecr.us-east-1.amazonaws.com
docker build -t helm-elasticedge-release/ee-v1-firewall .
docker tag helm-elasticedge-release/ee-v1-firewall:latest 112233445566.dkr.ecr.us-east-1.amazonaws.com/helm-elasticedge-release/ee-v1-firewall:latest
docker push 112233445566.dkr.ecr.us-east-1.amazonaws.com/helm-elasticedge-release/ee-v1-firewall:latest
```
#### HELM PUSH
```
aws ecr get-login-password --region us-east-1 | helm registry login --username AWS \
	     --password-stdin 112233445566.dkr.ecr.us-east-1.amazonaws.com
helm push ee-v1-firewall-1.2.0.tgz oci://112233445566.dkr.ecr.us-east-1.amazonaws.com/helm-dataplatform-release/
```

## Mount S3 bucket locally
```
apt update && apt install -y s3fs
mkdir -p /mnt/s3_volume
s3fs my-test-bucket /mnt/s3_volume/ -o iam_role=auto -o allow_other

root@ip-10-192-10-191:~# df -hT
Filesystem      Type       Size  Used Avail Use% Mounted on
/dev/root       ext4        49G   36G   13G  75% /
tmpfs           tmpfs      1.9G     0  1.9G   0% /dev/shm
tmpfs           tmpfs      772M  984K  771M   1% /run
tmpfs           tmpfs      5.0M     0  5.0M   0% /run/lock
/dev/nvme0n1p15 vfat       105M  6.1M   99M   6% /boot/efi
tmpfs           tmpfs      386M  4.0K  386M   1% /run/user/0
s3fs            fuse.s3fs   16E     0   16E   0% /mnt/s3_volume   <----- S3 bucket mounted on this location

aws s3 ls s3://my-test-bucket --recursive --human-readable --summarize
Total Objects: 833
   Total Size: 36.6 GiB
```

## Enable native S3 state locking
```
terraform {
  backend "s3" {
    bucket         = "tf-state-bucket"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}
```

## Workspaces

terraform workspace new dev

terraform workspace list

terraform workspace select dev

```
resource "aws_s3_bucket" "example" {
  bucket = "my-app-${terraform.workspace}"
  acl    = "private"
}
```

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
## Data block import
```
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

data "aws_instance" "nontf_instance" {
    instance_id = "i-044b2af955b1ae4e1"
}

output "nontf_instance_ip" {
    value = data.aws_instance.nontf_instance.public_ip
}
```
## VPC
```
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
```

## Security group and EC2 Instances
```
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
```
## Lookup and variables
```
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
```
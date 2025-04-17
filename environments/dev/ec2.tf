data "aws_ami" "launch_config_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "backend_ec2" {
  ami                         = data.aws_ami.launch_config_ami.id
  instance_type               = var.instance_type
  key_name		                = var.keypair
  vpc_security_group_ids      = ["${aws_security_group.backend_sec_grp.id}"]
  subnet_id		                = "${aws_subnet.dev_private_subnet1.id}"
  depends_on                  = [ aws_security_group.backend_sec_grp ]

  tags = {
    Name                      = "backend_ec2"
  }
}

resource "aws_instance" "frontend_ec2" {
  ami                         = data.aws_ami.launch_config_ami.id
  instance_type               = var.instance_type
  key_name		                = var.keypair
  vpc_security_group_ids      = ["${aws_security_group.frontend_sec_grp.id}"]
  subnet_id		                = "${aws_subnet.dev_public_subnet1.id}"
  associate_public_ip_address = true
  user_data                   = "${file("./environments/dev/userdata.sh")}"
  depends_on                  = [ aws_security_group.frontend_sec_grp ]

  tags = {
    Name                      = "frontend_ec2"
  }
}
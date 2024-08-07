variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "dev_public_subnet1_cidr" {
  default = "10.0.1.0/24"
}

variable "dev_public_subnet2_cidr" {
  default = "10.0.2.0/24"
}

variable "dev_private_subnet1_cidr" {
  default = "10.0.3.0/24"
}

variable "dev_private_subnet2_cidr" {
  default = "10.0.4.0/24"
}


variable "instance_type" {
  default = "t3.micro"
}

variable "keypair" {
  default = "webserver"
}


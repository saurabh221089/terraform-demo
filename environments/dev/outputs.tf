output "Instance_1" {
  description = "Instance ID of Frontend server"
  value = aws_instance.frontend_ec2.id
}

output "Instance_2" {
  description = "Instance ID of Backend server"
  value = aws_instance.backend_ec2.id
}

output "Public_IP" {
  description = "Public IP of Frontend server"
  value = aws_instance.frontend_ec2.public_ip
}

output "Public_dns" {
  description = "Public DNS of Frontend server"
  value = aws_instance.frontend_ec2.public_dns
}
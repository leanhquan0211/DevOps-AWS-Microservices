output "vpc_id" {
  description = "ID of the lab VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet."
  value       = aws_subnet.private.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway."
  value       = aws_nat_gateway.main.id
}

output "public_ec2_id" {
  description = "ID of the public EC2 instance."
  value       = aws_instance.public.id
}

output "public_ec2_public_ip" {
  description = "Public IP address of the public EC2 instance."
  value       = aws_instance.public.public_ip
}

output "private_ec2_id" {
  description = "ID of the private EC2 instance."
  value       = aws_instance.private.id
}

output "security_group_id" {
  description = "ID of the EC2 security group."
  value       = aws_security_group.ec2.id
}

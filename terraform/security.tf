resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for NT548 Lab 02 EC2 instances"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks       = var.allowed_ssh_cidrs
  description       = "Allow SSH access only from approved public IP CIDRs"
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "http" {
  # checkov:skip=CKV_AWS_260:HTTP from the internet is required to verify the public web server.
  type              = "ingress"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP access from the internet to the public demo server"
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow outbound traffic for package installation and instance updates"
  ip_protocol       = "-1"
}

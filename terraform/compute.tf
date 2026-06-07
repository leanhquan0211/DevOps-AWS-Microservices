data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

locals {
  public_instance_user_data = <<-EOT
    #!/bin/bash
    set -euxo pipefail

    dnf update -y
    dnf install -y nginx

    cat <<'HTML' > /usr/share/nginx/html/index.html
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>NT548 Lab02</title>
    </head>
    <body>
      <h1>NT548 Lab02 Terraform GitHub Actions</h1>
      <p>Public EC2 da duoc provision bang Terraform.</p>
    </body>
    </html>
    HTML

    systemctl enable nginx
    systemctl restart nginx
  EOT
}

resource "aws_instance" "public" {
  # checkov:skip=CKV_AWS_88:Public EC2 is required so the lab can verify web access from the internet.
  # checkov:skip=CKV_AWS_126:Detailed monitoring is intentionally disabled to keep the lab cost-conscious.
  # checkov:skip=CKV_AWS_135:EBS optimization is intentionally left at the AWS default for a small demo instance.
  # checkov:skip=CKV2_AWS_41:An IAM instance profile is not required for this introductory infrastructure lab.
  ami                         = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = local.public_instance_user_data

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-public-ec2"
    Tier = "public"
  }
}

resource "aws_instance" "private" {
  # checkov:skip=CKV_AWS_126:Detailed monitoring is intentionally disabled to keep the lab cost-conscious.
  # checkov:skip=CKV_AWS_135:EBS optimization is intentionally left at the AWS default for a small demo instance.
  # checkov:skip=CKV2_AWS_41:An IAM instance profile is not required for this introductory infrastructure lab.
  ami                         = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-private-ec2"
    Tier = "private"
  }
}

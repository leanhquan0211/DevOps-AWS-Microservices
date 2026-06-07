variable "aws_region" {
  description = "AWS region used to deploy the lab resources."
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
  default     = "nt548-lab02"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.20.2.0/24"
}

variable "allowed_ssh_cidrs" {
  description = "Danh sách CIDR được phép SSH vào EC2"
  type        = list(string)
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name used for SSH access."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for both lab instances."
  type        = string
  default     = "t3.micro"
}

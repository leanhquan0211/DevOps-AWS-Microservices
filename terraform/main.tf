data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  deployment_az = data.aws_availability_zones.available.names[0]

  common_tags = {
    Project     = var.project_name
    Environment = "lab"
    ManagedBy   = "terraform"
    Lab         = "NT548-Lab02-Part1"
  }
}

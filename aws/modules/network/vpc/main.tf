# --------------------------------------------
# VPC module
# --------------------------------------------
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name        = "${var.project_name}-${var.env}-vpc"
    name_prefix = var.project_name
    env         = var.env
  }
}

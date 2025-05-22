terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

#   backend "s3" {
#     bucket  = "agrico-terraform-bucket"
#     region  = "ap-northeast-1"
#     profile = "agripass"
#     key     = "stg.tfstate"
#     encrypt = true
#   }
}

provider "aws" {
  profile = "nislab"
  region  = "ap-northeast-1"
}

# ---------------------------------------------
# VPC module
# ---------------------------------------------
module "vpc" {
  source         = "../../modules/network/vpc"
  project_name   = var.project_name
  env            = var.env
}
# ---------------------------------------------
# Subnet module
# ---------------------------------------------
module "subnet" {
  source         = "../../modules/network/subnet"
  project_name   = var.project_name
  env            = var.env
  vpc_id         = module.vpc.vpc_id
}
# ---------------------------------------------
# ECR module
# ---------------------------------------------
module "ecr" {
  source         = "../../modules/ecr"
  project_name   = var.project_name
  env            = var.env
}

# ---------------------------------------------
# Lambda module
# ---------------------------------------------
module "lambda" {
  source         = "../../modules/server/lambda"
  ecr_repository_url = module.ecr.ecr_repository_url
  lambda_security_group_id = module.security_group.lambda_security_group_id
  public_subnet_ids = [module.subnet.public_subnet_id]
    api_gateway_id = module.api_gateway.api_gateway_id
}

# ---------------------------------------------
# API Gateway module
# ---------------------------------------------
module "api_gateway" {
  source         = "../../modules/network/api-gateway"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}

# ---------------------------------------------
# Security Group module
# ---------------------------------------------
module "security_group" {
  source         = "../../modules/network/security-group"
  project_name   = var.project_name
  env            = var.env
  vpc_id         = module.vpc.vpc_id
}

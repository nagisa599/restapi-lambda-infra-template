variable "env" {
  description = "Environment name"
  type        = string
}
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


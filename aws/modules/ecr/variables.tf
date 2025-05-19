variable "project_name" {
  description = "Prefix for resource names"
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "repository_type" {
  description = "Type of repository (frontend or backend)"
  type        = string
  default     = "serverless-backend"
}
variable "tags" {
  description = "Tags for the ecr resource"
  type        = map(string)
  default     = {}
}
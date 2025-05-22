variable ecr_repository_url {
    description = "ECR repository URL"
    type        = string
}
variable public_subnet_ids {
    description = "List of public subnet IDs"
    type        = list(string)
}
variable "lambda_security_group_id" {
    description = "Security group ID for the Lambda function"
    type        = string
}
variable "api_gateway_id" {
    description = "API Gateway ID"
    type        = string
}
output "lambda_security_group_id" {
  description = "The list of security group IDs"
  value       = aws_security_group.lambda_sg.id
}
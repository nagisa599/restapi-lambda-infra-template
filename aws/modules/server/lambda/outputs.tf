output "lambda_invoke_arn" {
  value = aws_lambda_function.go_lambda.invoke_arn
  description = "The ID of the Lambda function"
}
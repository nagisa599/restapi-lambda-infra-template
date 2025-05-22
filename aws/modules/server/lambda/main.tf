# --------------------------------------------
# Lambda のなりすましロールを作成
# --------------------------------------------
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}
# --------------------------------------------
# Lambda のなりすましロールにポリシーをアタッチ (最低限のポリシー: CloudWatch Logsnなど)
# --------------------------------------------
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# --------------------------------------------
# Lambda のなりすましロールにポリシーをアタッチ (VPCアクセス用)
# --------------------------------------------
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


# --------------------------------------------
# Lambda 
# --------------------------------------------
resource "aws_lambda_function" "go_lambda" {
  function_name = "go-ecr-lambda"
  role          = aws_iam_role.lambda_exec.arn
  package_type  = "Image"

  # ECRのlatestタグを使う（Terraformがキャッシュするから注意）
  image_uri     = "${var.ecr_repository_url}:latest"

  timeout = 10

  vpc_config {
    subnet_ids         = var.public_subnet_ids
    security_group_ids = [var.lambda_security_group_id]
  }
}
data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name =  aws_lambda_function.go_lambda.function_name # or aws_lambda_function.go_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:ap-northeast-1:${data.aws_caller_identity.current.account_id}:${var.api_gateway_id}/*/*"
}
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
# Lambda 
# --------------------------------------------
resource "aws_lambda_function" "go_lambda" {
  function_name = "go-ecr-lambda"
  role          = aws_iam_role.lambda_exec.arn
  package_type  = "Image"

  # ECRのlatestタグを使う（Terraformがキャッシュするから注意）
  image_uri     = "${var.ecr_repository_url}:latest"

  timeout = 10
}
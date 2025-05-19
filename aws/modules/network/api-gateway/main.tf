resource "aws_api_gateway_rest_api" "myapi" {
  name        = "RestAPI"
  description = "Supports GET, POST, PUT, DELETE"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.myapi.id
  parent_id   = aws_api_gateway_rest_api.myapi.root_resource_id
  path_part   = "test"
}
# ループでまとめるとシンプルになる
locals {
  methods = ["GET", "POST", "PUT", "DELETE"]
}

resource "aws_api_gateway_method" "proxy_methods" {
  for_each       = toset(local.methods)
  rest_api_id    = aws_api_gateway_rest_api.myapi.id
  resource_id    = aws_api_gateway_resource.proxy.id
  http_method    = each.key
  authorization  = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integrations" {
  for_each = toset(local.methods)
  rest_api_id             = aws_api_gateway_rest_api.myapi.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = each.key
  integration_http_method = "POST" # Lambdaを呼ぶときは常にPOST
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn

  depends_on = [aws_api_gateway_method.proxy_methods]
}
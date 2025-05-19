# lambda-infra-template

## 🧠 Integration の役割

たとえばこんな処理があるとしよう：

POST https://api.example.com/test
これだけじゃ「API Gateway はそのリクエストをどう処理するか？」がわからへん。

そこで Integration を定義しておくと…

type = "AWS_PROXY"
uri = aws_lambda_function.my_lambda.invoke_arn

「この /test エンドポイントに POST が来たら、Lambda 関数 my_lambda を POST で呼び出すんやで」

と設定できるわけや！

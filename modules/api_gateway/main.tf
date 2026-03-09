resource "aws_apigatewayv2_api" "rag_api" {

  name = "rag-api"

  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {

  api_id = aws_apigatewayv2_api.rag_api.id

  integration_type = "AWS_PROXY"

  integration_uri = var.lambda_invoke_arn

  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "query_route" {

  api_id = aws_apigatewayv2_api.rag_api.id

  route_key = "POST /query"

  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {

  api_id = aws_apigatewayv2_api.rag_api.id

  name = "$default"

  auto_deploy = true
}

resource "aws_lambda_permission" "api_gw_permission" {

  statement_id = "AllowAPIGatewayInvoke"

  action = "lambda:InvokeFunction"

  function_name = var.lambda_function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.rag_api.execution_arn}/*/*"
}
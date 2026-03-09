output "query_lambda_invoke_arn" {

  value = aws_lambda_function.query_lambda.invoke_arn
}

output "query_lambda_name" {

  value = aws_lambda_function.query_lambda.function_name
}
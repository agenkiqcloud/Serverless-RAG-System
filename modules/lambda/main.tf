resource "aws_iam_role" "lambda_role" {

  name = "rag_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Basic logging permissions
resource "aws_iam_role_policy_attachment" "lambda_basic" {

  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# DynamoDB permissions
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {

  name = "lambda-dynamodb-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = "arn:aws:dynamodb:ap-south-1:*:table/rag_metadata"
      }
    ]
  })
}

# S3 read permissions
resource "aws_iam_role_policy" "lambda_s3_policy" {

  name = "lambda-s3-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::*/*"
      }
    ]
  })
}

# Bedrock permissions
resource "aws_iam_role_policy" "lambda_bedrock_policy" {

  name = "lambda-bedrock-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = "*"
      }
    ]
  })
}

# Ingest Lambda
resource "aws_lambda_function" "ingest_lambda" {

  function_name = "rag_ingest_lambda"

  filename = "ingest.zip"

  handler = "ingest_lambda.handler"
  runtime = "python3.11"

  role = aws_iam_role.lambda_role.arn

  timeout = 30

  environment {
    variables = {
      DB_HOST     = var.db_host
      DB_NAME     = ""
      DB_USER     = ""
      DB_PASSWORD = ""
    }
  }
}

# Query Lambda
resource "aws_lambda_function" "query_lambda" {

  function_name = "rag_query_lambda"

  filename = "query.zip"

  handler = "query_lambda.handler"
  runtime = "python3.11"

  role = aws_iam_role.lambda_role.arn

  timeout = 30
}

output "ingest_lambda_arn" {
  value = aws_lambda_function.ingest_lambda.arn
}

output "ingest_lambda_name" {
  value = aws_lambda_function.ingest_lambda.function_name
}
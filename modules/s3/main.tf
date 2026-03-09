variable "bucket_name" {}

resource "aws_s3_bucket" "rag_bucket" {

  bucket = var.bucket_name

  tags = {
    Name = "rag-documents"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.rag_bucket.bucket
}

resource "aws_lambda_permission" "allow_s3" {

  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.rag_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {

  bucket = aws_s3_bucket.rag_bucket.id

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}
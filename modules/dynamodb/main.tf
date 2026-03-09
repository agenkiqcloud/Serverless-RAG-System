resource "aws_dynamodb_table" "rag_metadata" {

  name         = "rag_metadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "doc_id"

  attribute {
    name = "doc_id"
    type = "S"
  }

  tags = {
    Name = "rag-metadata"
  }
}
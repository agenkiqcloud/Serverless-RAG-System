resource "aws_db_subnet_group" "rag_db_subnet_group" {

  name = "rag-db-subnet-group"

  subnet_ids = var.public_subnets

  tags = {
    Name = "rag-db-subnet-group"
  }
}
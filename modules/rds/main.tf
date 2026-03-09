resource "aws_db_instance" "rag_postgres" {

  identifier = "rag-postgres-db"

  engine = "postgres"
  engine_version = "15"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  username = "ragadmin"
  password = "StrongPassword123"

  db_subnet_group_name = aws_db_subnet_group.rag_db_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.postgres_sg.id
  ]

  publicly_accessible = true

  skip_final_snapshot = true
}
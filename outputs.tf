output "s3_bucket" {
  value = module.s3.bucket_name
}

output "postgres_endpoint" {
  value = module.rds.db_endpoint
}

output "api_endpoint" {
  value = module.api_gateway.api_endpoint
}
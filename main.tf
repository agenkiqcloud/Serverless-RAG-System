provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "vpc" {
  source = "./modules/vpc"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  lambda_function_arn  = module.lambda.ingest_lambda_arn
  lambda_function_name = module.lambda.ingest_lambda_name
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "lambda" {

  source = "./modules/lambda"

  db_host = module.rds.db_endpoint
}

module "api_gateway" {

  source = "./modules/api_gateway"

  lambda_invoke_arn = module.lambda.query_lambda_invoke_arn

  lambda_function_name = module.lambda.query_lambda_name
}

module "rds" {
  source = "./modules/rds"

  vpc_id = module.vpc.vpc_id

  public_subnets = module.vpc.public_subnets
}


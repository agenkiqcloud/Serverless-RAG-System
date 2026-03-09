# Serverless RAG System with AWS Bedrock

This project implements a **Retrieval-Augmented Generation (RAG)**
architecture using AWS services. It allows users to upload documents to
Amazon S3, process them into embeddings, store them in PostgreSQL
(pgvector), and query them using large language models from Amazon
Bedrock.

------------------------------------------------------------------------

## Architecture Overview

Document Upload → S3 → Ingest Lambda → Bedrock Embeddings → PostgreSQL
(pgvector) User Query → API Gateway → Query Lambda → Vector Search →
Bedrock LLM → Response

------------------------------------------------------------------------

## AWS Services Used

-   Amazon S3 -- Document storage
-   AWS Lambda -- Serverless compute
-   Amazon Bedrock -- Embedding model and LLM
-   Amazon DynamoDB -- Metadata storage
-   Amazon API Gateway -- API endpoint for querying
-   Amazon RDS PostgreSQL -- Vector database (pgvector)
-   AWS IAM -- Access control

------------------------------------------------------------------------

## Technologies

-   Python
-   PostgreSQL + pgvector
-   Terraform
-   Docker
-   AWS CLI

------------------------------------------------------------------------

## Project Structure

terraform-aws-rag/ │ ├── lambda_code/ │ ├── ingest_lambda.py │ └──
query_lambda.py │ ├── modules/ │ ├── lambda/ │ ├── rds/ │ ├── s3/ │ ├──
dynamodb/ │ └── api_gateway/ │ ├── main.tf ├── variables.tf ├──
outputs.tf ├── Dockerfile ├── requirements.txt └── README.md

------------------------------------------------------------------------

## Database Schema

Enable pgvector:

CREATE EXTENSION vector;

Create table:

CREATE TABLE document_chunks ( id SERIAL PRIMARY KEY, file_name TEXT,
chunk_text TEXT, embedding VECTOR(1536) );

------------------------------------------------------------------------

## Environment Variables (Lambda)

DB_HOST=`<RDS_ENDPOINT>`{=html} DB_PORT=5432 DB_NAME=postgres
DB_USER=ragadmin DB_PASSWORD=`<password>`{=html}

------------------------------------------------------------------------

## Deployment Steps

Initialize Terraform:

terraform init

Preview infrastructure:

terraform plan

Deploy infrastructure:

terraform apply

------------------------------------------------------------------------

## Deploy Lambda Code

Build dependencies using Docker:

docker build -t rag-lambda .

Update Lambda function:

aws lambda update-function-code\
--function-name rag_ingest_lambda\
--zip-file fileb://ingest.zip

------------------------------------------------------------------------

## API Example

POST /query

Request:

{ "question": "Explain AWS Bedrock" }

Response:

{ "answer": "AWS Bedrock is a managed service providing foundation
models..." }

------------------------------------------------------------------------

## Use Cases

-   Enterprise document search
-   Knowledge base assistants
-   Customer support AI
-   Legal document analysis
-   Research document search

------------------------------------------------------------------------

## Future Improvements

-   Hybrid search (keyword + vector)
-   Authentication layer
-   Conversation memory
-   Streaming responses

------------------------------------------------------------------------

## License

MIT License

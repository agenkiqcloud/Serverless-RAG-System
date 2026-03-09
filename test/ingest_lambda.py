import json
import boto3
import uuid
import os

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")

TABLE_NAME = "rag_metadata"

table = dynamodb.Table(TABLE_NAME)

def handler(event, context):

    for record in event['Records']:

        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']

        doc_id = str(uuid.uuid4())

        # Example metadata save
        table.put_item(
            Item={
                "doc_id": doc_id,
                "file_name": key,
                "bucket": bucket,
                "status": "uploaded"
            }
        )

        print(f"Processed file {key}")

    return {
        "statusCode": 200,
        "body": json.dumps("File processed successfully")
    }
import json
import boto3
import psycopg2
import os
import uuid
from io import BytesIO

import PyPDF2

s3 = boto3.client("s3")
bedrock = boto3.client("bedrock-runtime",region_name="us-east-1")
dynamodb = boto3.resource("dynamodb")

table = dynamodb.Table("rag_metadata")
# Set the model ID, e.g., Titan Text Embeddings V2.
model_id = "amazon.titan-embed-text-v2:0"

# PostgreSQL connection
conn = psycopg2.connect(
    host=os.environ["DB_HOST"],
    database=os.environ["DB_NAME"],
    user=os.environ["DB_USER"],
    password=os.environ["DB_PASSWORD"],
    port=5432
)

cursor = conn.cursor()


# -------------------------------
# Extract text from PDF
# -------------------------------
def extract_pdf(file_stream):

    reader = PyPDF2.PdfReader(file_stream)

    text = ""

    for page in reader.pages:
        text += page.extract_text()

    return text





# -------------------------------
# Split text into chunks
# -------------------------------
def split_text(text, chunk_size=500):

    words = text.split()

    chunks = []

    for i in range(0, len(words), chunk_size):

        chunk = " ".join(words[i:i+chunk_size])

        chunks.append(chunk)

    return chunks


# -------------------------------
# Generate embedding
# -------------------------------
def generate_embedding(text):

    response = bedrock.invoke_model(
        modelId="amazon.titan-embed-text-v1",
        body=json.dumps({
            "inputText": text
        }),
        contentType="application/json",
        accept="application/json"
    )

    result = json.loads(response["body"].read())

    return result["embedding"]


# -------------------------------
# Store chunk in PostgreSQL
# -------------------------------
def store_vector(file_name, chunk, embedding):

    cursor.execute(
        """
        INSERT INTO document_chunks (file_name, chunk_text, embedding)
        VALUES (%s, %s, %s)
        """,
        (file_name, chunk, embedding)
    )

    conn.commit()


# -------------------------------
# Lambda handler
# -------------------------------
def handler(event, context):

    print("EVENT:", json.dumps(event))

    for record in event["Records"]:

        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]

        print("Processing file:", key)

        response = s3.get_object(Bucket=bucket, Key=key)

        file_stream = BytesIO(response["Body"].read())

        # detect file type
        if key.endswith(".pdf"):
            text = extract_pdf(file_stream)

       

        else:
            print("Unsupported file type")
            return

        chunks = split_text(text)

        print("Total chunks:", len(chunks))

        for chunk in chunks:

            embedding = generate_embedding(chunk)

            store_vector(key, chunk, embedding)

        # store metadata in DynamoDB
        table.put_item(
            Item={
                "doc_id": str(uuid.uuid4()),
                "file_name": key,
                "status": "indexed"
            }
        )

    return {
        "statusCode": 200,
        "body": "Document indexed successfully"
    }
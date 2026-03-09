import json
import boto3

bedrock = boto3.client("bedrock-runtime")

def handler(event, context):

    print('query lambda called')
    print("EVENT:", json.dumps(event))

    if "body" in event:
        body = json.loads(event["body"])
    else:
        body = event

    question = body.get("question", "Explain AWS Bedrock")

    prompt = f"""
    <|begin_of_text|>
    <|start_header_id|>user<|end_header_id|>

    Answer the question clearly.

    Question: {question}

    <|eot_id|>
    <|start_header_id|>assistant<|end_header_id|>
    """

    response = bedrock.invoke_model(
        modelId="meta.llama3-70b-instruct-v1:0",
        body=json.dumps({
            "prompt": prompt,
            "max_gen_len": 300,
            "temperature": 0.5
        }),
        contentType="application/json",
        accept="application/json"
    )

    result = json.loads(response["body"].read())

    answer = result["generation"]

    return {
        "statusCode": 200,
        "body": json.dumps({
            "question": question,
            "answer": answer
        })
    }
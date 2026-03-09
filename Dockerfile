FROM public.ecr.aws/lambda/python:3.11

COPY lambda_code/requirements.txt .

RUN pip install -r requirements.txt -t .

COPY lambda_code/ingest_lambda.py .

CMD ["ingest_lambda.handler"]
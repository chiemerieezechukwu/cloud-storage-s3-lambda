import os

import boto3
from lambda_router import LambdaRouter

from utils import S3ActionsManager

app = LambdaRouter()


OBJECT_STORAGE_BUCKET = os.environ.get("OBJECT_STORAGE_BUCKET")

# instantiate s3_client to be reused in subsequent invocations
s3_client = boto3.client("s3")
s3_manager = S3ActionsManager(s3_client=s3_client, storage_bucket=OBJECT_STORAGE_BUCKET)

import endpoints  # noqa: E402 F401

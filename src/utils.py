from lambda_router.exceptions import Exception500

from custom_logger import logger


class S3ActionsManager:
    def __init__(self, s3_client, storage_bucket):
        self.s3_client = s3_client
        self.storage_bucket = storage_bucket
        logger.debug("Instantiated S3ActionsManager")

    def get_presigned_post(self, request):
        _ret = self.s3_client.generate_presigned_post(
            Bucket=self.storage_bucket,
            Key=self.get_object_key(request),
            Fields={
                "acl": "private",
                "Content-Type": "application/octet-stream",
                "x-amz-algorithm": "AWS4-HMAC-SHA256",
            },
            Conditions=[
                {"acl": "private"},
                {"bucket": self.storage_bucket},
                {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
                {"Content-Type": "application/octet-stream"},
                ["eq", "$key", self.get_object_key(request)],
            ],
            ExpiresIn=3600,
        )
        return _ret

    def get_presigned_url(self, request):
        _ret = self.s3_client.generate_presigned_url(
            ClientMethod="get_object",
            Params={
                "Bucket": self.storage_bucket,
                "Key": self.get_object_key(request),
            },
            ExpiresIn=3600,
        )
        return _ret

    def delete_object(self, request):
        key = self.get_object_key(request)
        _ret = self.s3_client.delete_object(
            Bucket=self.storage_bucket,
            Key=key,
        )
        logger.debug(f"Object with key '{key}' deleted. response: {_ret}")

    def get_object_key(self, request):
        key = request.args.get("key")
        if key:
            return key
        raise Exception500("The object key is not specified in the query string")

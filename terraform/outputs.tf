output "lambda_url" {
  description = "Base URL for the deployed lambda function"

  value = aws_lambda_function_url.s3_storage_lambda_url.function_url
}

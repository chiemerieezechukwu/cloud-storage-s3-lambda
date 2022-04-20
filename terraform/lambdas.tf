# determine if the code has changed to run the null_resource
data "archive_file" "src_zip" {
  source_dir  = local.source_code_dir
  output_path = local.source_code_zip
  type        = "zip"
}

resource "null_resource" "install_python_dependencies" {
  triggers = {
    src_hash = data.archive_file.src_zip.output_base64sha256
  }

  provisioner "local-exec" {
    command = "cd ${local.code_base_root} && bash ${local.code_base_root}/scripts/package.sh"

    environment = {
      actor = "terraform"
    }
  }
}

data "archive_file" "create_lambda_dist_pkg" {
  depends_on  = [null_resource.install_python_dependencies]
  source_dir  = local.dist_code_dir
  output_path = local.dist_code_zip
  type        = "zip"
}

resource "aws_lambda_function" "s3_storage_lambda" {
  function_name    = local.function_name
  handler          = "lambda_function.lambda_handler"
  runtime          = var.runtime
  role             = aws_iam_role.s3_storage_lambda_exec_role.arn
  memory_size      = 128
  timeout          = 3
  depends_on       = [null_resource.install_python_dependencies]
  source_code_hash = data.archive_file.create_lambda_dist_pkg.output_base64sha256
  filename         = data.archive_file.create_lambda_dist_pkg.output_path
  environment {
    variables = {
      OBJECT_STORAGE_BUCKET = aws_s3_bucket.object_storage_bucket.id
    }
  }
}

resource "null_resource" "clean_up_packages" {
  depends_on = [aws_lambda_function.s3_storage_lambda]
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = "rm -rf ${local.code_base_root}/dist && rm -rf ${local.code_base_root}/tmp"
  }
}

resource "aws_lambda_function_url" "s3_storage_lambda_url" {
  function_name      = aws_lambda_function.s3_storage_lambda.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

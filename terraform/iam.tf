resource "aws_iam_role" "s3_storage_lambda_exec_role" {
  name = local.lambda_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

data "aws_iam_policy_document" "lambda_basic_exec_policy_doc" {
  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_policy" "lambda_basic_exec_policy" {
  name   = "${local.lambda_policy_name}-basic-exec"
  policy = data.aws_iam_policy_document.lambda_basic_exec_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_basic_exec_policy.arn
  role       = aws_iam_role.s3_storage_lambda_exec_role.name
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name = "${local.lambda_policy_name}-s3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:DeleteObject",
      ]
      Effect = "Allow"
      Resource = [
        "${aws_s3_bucket.object_storage_bucket.arn}"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
  role       = aws_iam_role.s3_storage_lambda_exec_role.name
}

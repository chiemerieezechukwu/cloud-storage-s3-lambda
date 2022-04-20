locals {
  code_base_root  = abspath("${path.module}/..")
  source_code_dir = abspath("${path.module}/../src")
  source_code_zip = abspath("${path.module}/../tmp/src.zip")
  dist_code_dir   = abspath("${path.module}/../dist")
  dist_code_zip   = abspath("${path.module}/../tmp/dist.zip")

  function_name      = "${terraform.workspace}-${var.suffix}-lambda"
  lambda_role_name   = "${terraform.workspace}-${var.suffix}-lambda-role"
  lambda_policy_name = "${terraform.workspace}-${var.suffix}-lambda-policy"
  bucket_name_prefix = "${terraform.workspace}-${var.suffix}-bucket-"
}

# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "eu-central-1"
}

variable "runtime" {
  type    = string
  default = "python3.9"
}

variable "suffix" {
  type    = string
  default = "s3-storage"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "dev_s3" {
  bucket_prefix = "dev-"

  tags = {
    Environment          = "Dev"
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/simple_s3.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "dev_s3"
    yor_trace            = "0b82242e-01d8-42b5-88f3-78f80247286c"
  }
}



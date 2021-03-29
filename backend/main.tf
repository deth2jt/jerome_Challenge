
locals {
  terraform_config = <<-EOT

    terraform {
        backend "s3" {
            bucket         = "${var.bucket}"
            key            = "${var.key}"
            region         = "us-east-1"
            
            dynamodb_table = "${var.dynamodb_table}"
            encrypt        = true
        }
    }
  EOT
}

resource "local_file" "postfix_config" {
  filename = "${path.root}/terraform.tf"
  content  = local.terraform_config
}
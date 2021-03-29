provider "aws" {
	region = "us-east-1"
}

resource "random_id" "my-random-id" {
    byte_length = 2
}

resource "aws_s3_bucket" "my-code-deploy-bucket" {
    bucket = "${var.s3_buck_name}-${random_id.my-random-id.dec}"
    acl = "private"

    versioning {
        enabled = true
    }

    lifecycle_rule {
        enabled = true

        transition {
            storage_class = "STANDARD_IA"
            days = 30
        }
    }

    tags = {
        Name = "foobar-s3-tagged"
    }

}


resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-1-${random_id.my-random-id.dec}"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

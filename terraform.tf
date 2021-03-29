
terraform {
    backend "s3" {
        bucket         = "terraform-state-1-17524"
        key            = "terraform.tfstate"
        region         = "us-east-1"
            
        dynamodb_table = "terraform-up-and-running-locks"
        encrypt        = true
    }
}

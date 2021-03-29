output "bucket_name" {
    value = "${aws_s3_bucket.my-code-deploy-bucket.id}"
}

output "terra_bucket_name" {
    value = "${aws_s3_bucket.terraform_state.id}"
}


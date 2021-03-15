output "bucket_name" {
    value = "${aws_s3_bucket.my-code-deploy-bucket.id}"
}


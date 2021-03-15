output "secret_string" {
    value = "${aws_secretsmanager_secret_version.secret.secret_string}"
}
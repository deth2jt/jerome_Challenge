resource "aws_secretsmanager_secret" "secret" {
  description               = "${var.description}"
  kms_key_id                = "${var.kms_key}"
  name                      = "${var.name}-secret"
  recovery_window_in_days   = 7
}


resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = "${aws_secretsmanager_secret.secret.id}"
  secret_string = "${var.secret_string}"
}
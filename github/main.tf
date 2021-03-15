#https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token
provider "github" {
  #token = "${var.github_token}"
  #owner = "${var.github_owner}"
}


resource "github_actions_secret" "github-action-s3-buck-name" {
  repository       = var.repository
  secret_name      = var.secret_name
  plaintext_value  = var.bucket_name_value
}

resource "github_actions_secret" "github-action-terraform-access-id" {
  repository       = var.repository
  secret_name      = "AWS_ACCESS_KEY_ID"
  plaintext_value  = var.AWS_ACCESS_KEY_ID
}

resource "github_actions_secret" "github-action-terraform-access-key" {
  repository       = var.repository
  secret_name      = "AWS_SECRET_ACCESS_KEY"
  plaintext_value  = var.AWS_SECRET_ACCESS_KEY
}
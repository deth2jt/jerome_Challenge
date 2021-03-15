
provider "aws" {
  region = "us-east-1"
  #version = "1.40.0"
}

module "iam" {
  source        = "./iam"
  iam_role_list = ["CodeDeployInstanceRole", "CodeDeployServiceRole"]
  policy1       = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy", "arn:aws:iam::aws:policy/service-role/AutoScalingNotificationAccessRole"]
  policy2       = ["arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"]
  #policy_list   = [policy1, policy2]
}

data "aws_caller_identity" "current" {}


module "kms" {
  source    = "./kms"
  user_name = data.aws_caller_identity.current.arn
}


output "caller_arn" {
  value = module.kms.kms_key.id
}


module "s3" {
  source       = "./s3"
  s3_buck_name = "aws-codedeploy-deployments"
}

module "vpc" {
  source       = "./vpc"
  vpc_cidr     = "10.0.0.0/16"
  public_cidrs = ["10.0.0.0/24", "10.0.2.0/24"]
  #private_cidrs   = ["10.0.1.0/24", "10.0.3.0/24"]
  #transit_gateway = module.transit_gateway.transit_gateway
}

module "sms" {
  source = "./sms"

  description = "public key"
  kms_key     = module.kms.kms_key.id
  #secret_string = "file(file:///home/userone/.ssh/test_rsa.pub)"
  secret_string = file("/home/userone/.ssh/test_rsa.pub")
  name          = "public_foo_key"
}



output "public_key" {
  value = module.sms.secret_string
}


module "ec2" {
  source = "./ec2"
  owners = "099720109477"

  image_id       = "ami-013f17f36f8b1fefb"
  image_location = "099720109477/ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20210224"
  name           = "*ubuntu-bionic-18.04-amd64-server-20210224*"

  
  iam_profile_name = module.iam.code_deploy_inst_profile
  #my_public_key  = "${data.aws_secretsmanager_secret_version.current.secret_string}"
  my_public_key  = module.sms.secret_string
  instance_type  = "t2.micro"
  security_group = module.vpc.security_group
  subnets        = module.vpc.public_subnets
  ec2_tags       = ["${var.name_tage}", "${var.env_tage}"]
}

//expected compute_platform to be one of [ECS Lambda Server], got EC2/On-premises
module "codedeploy" {
  source = "./codedeploy"

  compute_platform      = "Server"
  app_name              = var.name_tage
  deployment_group_name = var.env_tage
  iam_deploy_name       = module.iam.code_deploy_service_role.arn
}

module "github" {
  source = "./github"

  repository            = var.repo_name
  secret_name           = var.buck_name_git_id
  bucket_name_value     = module.s3.bucket_name
  AWS_ACCESS_KEY_ID     = trimspace(split( "=",   split("\n", file("~/.aws/credentials"))[1] )[1])
  AWS_SECRET_ACCESS_KEY = trimspace(split( "=",   split("\n", file("~/.aws/credentials"))[2] )[1])

}



/*
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn2" {
  value = data.aws_caller_identity.current.arn
}

#TO B E USED
output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "caller_sssh1" {
  value = trimspace(split( "=",   split("\n", file("~/.aws/credentials"))[1] )[1])
}

output "caller_sssh2" {
  value = trimspace(split( "=",   split("\n", file("~/.aws/credentials"))[2] )[1])
}
*/



/*
data "aws_secretsmanager_secret" "public_key1" {
  name = "my_pub_data2"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.public_key1.id
}

resource "local_file" "foo" {
    content     = "${module.sms.secret_string}"
    filename = "${path.module}/foo.bar"
}
*/
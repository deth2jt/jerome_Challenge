provider "aws" {
	region = "us-east-1"
}

resource "aws_iam_role" "code_deploy_inst_role" {
    name = "${var.iam_role_list[0]}"

    assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": [
            "ec2.amazonaws.com"
            ]
        },
        "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_role" "code_deploy_service_role" {
    name = "${var.iam_role_list[1]}"

    assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": [
            "codedeploy.amazonaws.com"
            ]
        },
        "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_instance_profile" "foo_profile" {
  name = "foo_profile_codedeploy"
  role = "${aws_iam_role.code_deploy_inst_role.name}"
}

resource "aws_iam_role_policy_attachment" "test-attach" {
    count         = "${length(var.policy1)}"
    #name          = "test-attachment-${count.index}"
  
    #users      = "$"
    role       = "${aws_iam_role.code_deploy_inst_role.id}"
    policy_arn      = "${element(var.policy1,count.index)}"
    
}


resource "aws_iam_role_policy_attachment" "test-attach2" {
    count         = "${length(var.policy2)}"
    #ame          = "test-attachment2-${count.index}"
  
    #users      = "$"
    role       = "${aws_iam_role.code_deploy_service_role.id}"
    policy_arn      = "${element(var.policy2,count.index)}"
    
}


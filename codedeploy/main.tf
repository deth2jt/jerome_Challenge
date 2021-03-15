resource "aws_codedeploy_app" "foo_app" {
  compute_platform = "${var.compute_platform}"
  name             = "${var.app_name}"
}

resource "aws_codedeploy_deployment_group" "foo" {
    app_name               = "${aws_codedeploy_app.foo_app.name}"
    deployment_group_name  = "${var.deployment_group_name}"
    service_role_arn       = "${var.iam_deploy_name}"
    #deployment_config_name = aws_codedeploy_deployment_config.foo.id

    deployment_config_name = "CodeDeployDefault.OneAtATime" # AWS defined deployment config
  
    ec2_tag_set {
        ec2_tag_filter  {
            key   = "Name"
            type  = "KEY_AND_VALUE"
            value = "${var.app_name}"
        }   

        ec2_tag_filter  {
            key   = "env"
            type  = "KEY_AND_VALUE"
            value = "${var.deployment_group_name}"
        }
    }

    # trigger a rollback on deployment failure event
    auto_rollback_configuration {
        enabled = true
        events = [
        "DEPLOYMENT_FAILURE",
        ]
    }
}

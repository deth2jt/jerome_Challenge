output "code_deploy_service_role" {
    value = "${aws_iam_role.code_deploy_service_role}"
}

output "code_deploy_inst_role" {
    value = "${aws_iam_role.code_deploy_inst_role.id}"
}

output "code_deploy_inst_profile" {
    value = "${aws_iam_instance_profile.foo_profile.name}"
}
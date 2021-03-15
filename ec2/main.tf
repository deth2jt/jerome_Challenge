provider "aws" {
	region = "us-east-1"
}

data "aws_availability_zones" "available" {}


data "aws_ami" "centos" {
#data "aws_ami" "redhat" {
    owners = ["${var.owners}"]
    most_recent = true
    #image_id = "${var.image_id}"
    #image_location = "${var.image_location}"
    #name = "${var.name}"

    
    filter {
        name   = "name"
        values = ["${var.name}"]
    }

    filter {
      name   = "architecture"
      values = ["x86_64"]
    }


    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }
    
}




resource "aws_key_pair" "myfoo-key" {
    key_name = "my_foo_terraform_key"
    #public_key = "${data.aws_secretsmanager_secret.public_key}"
    public_key = "${var.my_public_key}"
}

data "template_file" "init" {
    template = "${file("${path.module}/userdata.tpl")}"

}

resource "aws_instance" "my-foo-instance" {
    #count = 1
    #owners = "${var.owners}"
    
    #image_id = "${var.image_id}"
    #image_location = "${var.image_location}"
    #name = "${var.name}"
    #most_recent = true

    #ami = "${var.image_id}"
    ami = "${data.aws_ami.centos.id}"
    iam_instance_profile = "${var.iam_profile_name}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.myfoo-key.id}"
    vpc_security_group_ids = ["${var.security_group}"]
    subnet_id = "${element(var.subnets, 0)}"
    user_data = "${data.template_file.init.rendered}"

    tags = {
        name = "${element(var.ec2_tags, 0)}"
        env = "${element(var.ec2_tags, 1)}"
    }
}

/*
resource "random_integer" "int" {
    min     = 0
    max     = "${length(data.aws_availability_zones.available.names)}"
    #count   = "${var.numberOfMachines}"
}
*/


resource "aws_ebs_volume" "my-foo-ebs" {
    #count = 1
    #availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    availability_zone = "us-east-1a"
    size = 8
    type = "gp2"
}


resource "aws_volume_attachment" "my-vol-attch" {
    #count = 2
    device_name = "/dev/xvdh"
    instance_id = "${aws_instance.my-foo-instance.id}"
    volume_id = "${aws_ebs_volume.my-foo-ebs.id}"
    force_detach = true
}
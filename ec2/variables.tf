variable "my_public_key" {}

variable "instance_type" {}

variable "security_group" {
    #type = string
    description = "(optional) describe your variable"
}

variable "iam_profile_name" {}

variable "subnets" {
    type = "list"
}

variable "ec2_tags" {
    type = "list"
}


variable "owners" {
    #type = "list"
}

variable "image_id" {}

variable "image_location" {}

variable "name" {}


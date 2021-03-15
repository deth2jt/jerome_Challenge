#https://www.devopsschool.com/blog/example-code-of-terrform-aws-vpc/
provider "aws" {
	region = "us-east-1"
}


data "aws_availability_zones" "available" {}


resource "aws_vpc" "main" {
	cidr_block = "${var.vpc_cidr}"
	enable_dns_hostnames = true
	enable_dns_support = true

	tags = {
		Name = "foo-terraform-vpc"
	}
}

resource "aws_internet_gateway" "gw" {
	vpc_id = "${aws_vpc.main.id}"

	tags = {
		Name = "foo-terraform-igw"
	}
}


resource "aws_subnet" "public_subnet" {
	#count = 2
	count = "${length(var.public_cidrs)}"
	cidr_block = "${var.public_cidrs[count.index]}"
	vpc_id = "${aws_vpc.main.id}"
	map_public_ip_on_launch  = true
	#drop in atleast 2 subnet well atleast size of public subnet a+b
	availability_zone = "${ data.aws_availability_zones.available.names[count.index]}"


	tags = {
    	Name = "my-foo-public-subnet.${count.index + 1}"
  	}
}



resource "aws_route_table_association" "public_subnet_assoc" {
	#count = "${length(var.subnet_cidrs_public)}"
	count = 2
	route_table_id = "${aws_default_route_table.public_route.id}"
	subnet_id = "${aws_subnet.public_subnet.*.id[count.index]}"
	#depends_on = ["aws_route_table.public_route","aws_subnet.public_subnet"]
	#depends_on = ["aws_default_route_table.private_route","aws_subnet.private_subnet"]
}

resource "aws_security_group" "foo_sg" {
	name = "my-foo-sg"
	vpc_id = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "ssh_inbound_access" {
	from_port = 22
	protocol = "tcp"
	security_group_id = "${aws_security_group.foo_sg.id}"
	to_port = 22
	type = "ingress"
	cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http_inbound_access" {
	from_port = 80
	protocol = "tcp"
	security_group_id = "${aws_security_group.foo_sg.id}"
	to_port = 80
	type = "ingress"
	cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_inbound_access" {
	from_port = 443
	protocol = "tcp"
	security_group_id = "${aws_security_group.foo_sg.id}"
	to_port = 443
	type = "ingress"
	cidr_blocks = ["0.0.0.0/0"]
}



resource "aws_security_group_rule" "all_outbound_access" {
	from_port = 0
	protocol = "-1"
	security_group_id = "${aws_security_group.foo_sg.id}"
	to_port = 0
	type = "egress"
	cidr_blocks = ["0.0.0.0/0"]
}



#resource "aws_default_route_table" "private_route" {
resource "aws_default_route_table" "public_route" {
    default_route_table_id = "${aws_vpc.main.default_route_table_id}"
    
	/*
	already defined
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
	*/

    tags = {
        Name = "foo-terraform-rt"
    }
}



resource "aws_route" "my-tgw-route" {
  route_table_id         = "${aws_default_route_table.public_route.id}"
  #route_table_id         = "${aws_route_table.public_route.id}"
  destination_cidr_block = "0.0.0.0/0"
  #transit_gateway_id     = "${var.transit_gateway}"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

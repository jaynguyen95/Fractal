# This used to declare the use of resources provided by AWS.
provider "aws" {
  region = "${var.aws_region}"
}

# This defines a vpc and the cidr block it exists on.
resource "aws_vpc" "fractal_vpc" {
  cidr_block = "${var.vpc_cidr}"
}

# This creates the public subnet in the vpc created above.
data "aws_subnet" "public_subnet" {
  vpc_id     = "${aws_vpc.fractal_vpc.id}"
  cidr_block = "${var.public_cidr}"

  tags {
    Name = "Main Public Subnet"
  }
}

# This creates the private subnet in the vpc created above.
data "aws_subnet" "private_subnet" {
  vpc_id     = "${aws_vpc.fractal_vpc.id}"
  cidr_block = "${var.private_cidr}"

  tags {
    Name = "Main Private Subnet"
  }
}

# This creates an instance with the given ami ID and configured within the private subnet and attached is the security group for the instance.
resource "aws_instance" "test_instance" {
  ami = "ami-0274e11dced17bb5b"
  instance_type = "t2.micro"
  key_name = "test"
  vpc_security_group_ids = ["${aws_security_group.test_instance_sg.id}"]
  subnet_id = "${data.aws_subnet.private_subnet.id}"
  tags {
    Name = "This is a test instance"
  }
}

# This is the elb fronting the instance.
resource "aws_elb" "elb_service" {
    name = "test-instance-elb"
    instances = ["${aws_instance.test_instance.id}"]
    security_groups = ["${aws_security_group.test_instance_sg.id}"]
    subnets = ["${data.aws_subnet.private_subnet.id}"]
    internal = "${var.elb_internal}"
    idle_timeout = "${var.elb_timeout}"
    health_check {
        healthy_threshold = "2"
        unhealthy_threshold = "5"
        timeout = "60"
        target = "TCP:8443"
        interval = "30"
    }
    tags {
        Name = "${var.name}_elb"
    }
    listener {
        instance_port = "22"
        instance_protocol = "tcp"
        lb_port = "22"
        lb_protocol = "tcp"
    }
    listener {
        instance_port = "8443"
        instance_protocol = "tcp"
        lb_port = "8443"
        lb_protocol = "tcp"
    }
}

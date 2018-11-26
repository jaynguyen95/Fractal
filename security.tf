resource "aws_security_group" "public_subnet_sg" {
  vpc_id = "${data.aws_subnet.public_subnet.vpc_id}"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
  }
}

resource "aws_security_group" "private_subnet_sg" {
  vpc_id = "${data.aws_subnet.private_subnet.vpc_id}"

  ingress {
    cidr_blocks = ["${var.private_cidr}"]
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
  }
}

resource "aws_security_group" "test_instance_sg" {
  name = "${var.name}_sg"
  description = "This is the test instances security group"
  vpc_id = "${data.aws_subnet.public_subnet.vpc_id}"
  tags {
    Name = "test_instance_sg"
  }
}

resource "aws_security_group" "elb_sg" {
  name = "${var.name}_elb_sg"
  description = "This is the test instances elb security group"
  vpc_id = "${data.aws_subnet.public_subnet.vpc_id}"
  tags {
    Name = "test_instance_elb_sg"
  }
}

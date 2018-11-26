################################################################################ CONFIGURATION VARIABLES ################################################################################

variable "aws_region" { default = "eu-west-2" }

################################################################################ NETWORKING VARIABLES ################################################################################

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.8.0.0/16"
}

variable "public_cidr" {
  description = "CIDR for the public subnet"
  default = "10.8.1.0/24"
}

variable "private_cidr" {
  description = "CIDR for the private subnet"
  default = "10.8.2.0/24"
}

################################################################################ INSTANCE VARIABLES ################################################################################

variable "name" { default = "test_instance" }
variable "elb_timeout" { default = "60" }
variable "elb_internal" { default = "true" }

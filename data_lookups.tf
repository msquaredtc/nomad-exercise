/*
    This provides various lookups on AWS assets for our deployment
*/

// Lookup VPC by name through passed variables
data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = ["${var.deployed_by}-${var.company}-${var.environment}-vpc"]
  }
}

// Lookup Ubuntu image
data "aws_ami" "ubuntu" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-kinetic-22.10-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
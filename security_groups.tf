/*
    Required Nomad cluster security groups
*/

// UI access
resource "aws_security_group" "nomad_ui" {
  name   = "tf-${var.company}-${var.name}-${var.environment}-ui"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port       = 4646
    to_port         = 4646
    protocol        = "tcp"
    cidr_blocks     = [var.allowed_ip]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Access to instances via SSH
resource "aws_security_group" "ssh" {
  name   = "tf-${var.company}-${var.name}-${var.environment}-ssh"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Cluster internal access
resource "aws_security_group" "nomad_internal" {
  name   = "tf-${var.company}-${var.name}-${var.environment}-internal"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
}

// Cluster client access to main nodes
resource "aws_security_group" "nomad_client" {
  name   = "tf-${var.company}-${var.name}-${var.environment}-client"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add application ingress rules here
  # These rules are applied only to the client nodes

  # nginx example
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
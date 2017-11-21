provider "aws" {
  region = "ap-southeast-1"
  version = "~> 1.3"
}

resource "aws_instance" "workstation" {
  ami = "ami-0e13686d"
  instance_type = "t2.medium"
  key_name = "vincentdesmet"

  vpc_security_group_ids = [ "${aws_security_group.chef_training.id}" ]

  tags {
    Name = "Chef Workstation"
    Owner = "Vincent"
  }
}

data "aws_vpc" "main" {
  id = "vpc-3d2eda58"
}

resource "aws_security_group" "chef_training" {
  name        = "chef_training"
  description = "Ports required for Chef training"
  vpc_id      = "${data.aws_vpc.main.id}"


  # RDP
  ingress {
    from_port   = 3389 
    to_port     = 3389
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # WinRM
  ingress {
    from_port   = 5985
    to_port     = 5985
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "Chef Workstation"
    Owner = "Vincent"
  }
}

output "instance_id" {
  value = "${aws_instance.workstation.id}"
}

output "instance_ip" {
  value = "${aws_instance.workstation.public_ip}"
}



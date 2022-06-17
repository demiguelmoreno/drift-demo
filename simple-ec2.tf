# Simple instance template

provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "mdemiguelmor-SG" {
  name = "mdemiguelmor-ssh_traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    yor_trace = "975e871f-0b8c-46d4-b2de-4b8499818559"
  }
}

resource "aws_instance" "mdemiguelmor-EC2" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.mdemiguelmor-SG.name}"]
  key_name        = "linux-key-pair"
  tags = {
    yor_trace = "1bc48160-da4d-4af7-b73d-2f6b1ac39f79"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

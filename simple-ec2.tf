# Simple instance template

provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "ssh_traffic" {
  name        = "mdemiguelmor-ssh_traffic"
  description = "Allow SSH inbound traffic"
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    yor_trace = "7cc8165d-c737-466b-99ab-97e81f2ac3ef"
  }
}

resource "aws_instance" "web_server_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.ssh_traffic.name}"]
  tags = {
    yor_trace = "b44dfe3a-d183-466f-81e4-f7b0046f45a9"
  }
  key_name = "linux-key-pair"
  ebs_optimized = true
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

# Simple instance template

provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "ssh_traffic" {
  name = "mdemiguelmor-ssh_traffic"
  description = "Allow SSH inbound traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.ssh_traffic.name}"]
  key_name        = "linux-key-pair"
  ebs_optimized   = true
}

data "aws_ami" "ubuntu" {
  most_recent     = true

  filter {
    name          = "name"
    values        = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  
  filter {
    name          = "virtualization-type"
    values        = ["hvm"]
  }

  owners          = ["099720109477"] # Canonical
}

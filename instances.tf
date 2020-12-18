variable "project" {}
variable "region" {}
variable "profile" {}
variable "public_key" {}
variable "attach_public_ip" {
  type = bool
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_key_pair" "example-server-keypair" {
  key_name   = "${var.project}-server-keypair"
  public_key = var.public_key
}

resource "aws_instance" "example-server" {
  ami                         = "ami-0be3f0371736d5394" // Ubuntu 20.04 LTS
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.example-server-keypair.key_name
  associate_public_ip_address = var.attach_public_ip
  disable_api_termination     = false
  monitoring                  = false

  root_block_device {
    volume_type           = "standard"
    volume_size           = 10
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name    = "${var.project}-${var.region}-server"
    Project = var.project
    Role    = "ec2"
    Backup  = "true"
  }
}
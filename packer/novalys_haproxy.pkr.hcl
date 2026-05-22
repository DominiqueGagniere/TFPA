packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

source "amazon-ebs" "novalys_haproxy" {
  profile       = "default"
  ami_name      = "novalys_haproxy"
  instance_type = "${var.instance_type}"
  region        = "eu-west-3"
  ssh_username  = "admin"
  # Source AMI define the base image for the build 
  # Debian 13 AMI ID below
  source_ami = "ami-03dbc12aeff16b2d4"
  tags = {
    version = "1.0"
  }
}

build {
  sources = ["source.amazon-ebs.novalys_haproxy"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y haproxy"
    ]
  }
}
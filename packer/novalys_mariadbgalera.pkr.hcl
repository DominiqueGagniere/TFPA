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

source "amazon-ebs" "novalys_mariadbgalera" {
  profile       = "default"
  ami_name      = "novalys_mariadbgalera2"
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
  sources = ["source.amazon-ebs.novalys_mariadbgalera"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "curl -LsSO https://r.mariadb.com/downloads/mariadb_repo_setup",
      "chmod +x mariadb_repo_setup",
      "sudo bash mariadb_repo_setup",
      "sudo apt-get install mariadb-server mariadb-client galera-4 -y"
    ]
  }
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.94.1"
    }
  }
    # Version minimum de Terraform CLI
    # required_version = ">= 1.1.0"
}

provider "aws" {
    profile = "default"
    region = "eu-west-3" 
}

# Mention du type de ressource déployer "aws_instance" = "EC2" et son nom 
resource "aws_instance" "www" {
  for_each = var.www_configuration
    # AMI of novalys_nginx built with Packer
    ami           = "ami-076deb7dca265a6b5"
    
    # AWS Free Tier compatible 
    instance_type = "t2.micro"

    # Choisi des régles de sécurité à appliquer, ici "ssh" pour autoriser le 22 
    # Il faut la créer au préalable dans Console sous le nom "ssh" 
    # Ajout de httphttps pour autoriser le 80 et 443
    security_groups = ["ssh", "httphttps"]

    user_data = <<-EOT
    #cloud-config
    users:
      - name: ${var.automation_useracc_name}
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
          - ${var.automation_useracc_ssh_public_key}
    EOT

    tags = {
      Name = each.value.instance_name
      role = "web"
    }
}

resource "aws_instance" "rproxy" {
  for_each = var.rproxy_configuration
    # AMI of novalys_haproxy built with Packer
    ami           = "ami-0fd91a7fea6b2b38c"
    
    # AWS Free Tier compatible 
    instance_type = "t2.micro"
    security_groups = ["ssh", "httphttps", "8404allow"]

    user_data = <<-EOT
    #cloud-config
    users:
      - name: ${var.automation_useracc_name}
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
          - ${var.automation_useracc_ssh_public_key}
    EOT

    tags = {
      Name = each.value.instance_name
      role = "rproxy"
    }
}
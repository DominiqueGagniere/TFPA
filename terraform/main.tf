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

# Define the policy document for managing elastic IPs
data "aws_iam_policy_document" "ec2_elastic_ip_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeAddresses",
      "ec2:AssociateAddress"
    ]
    resources = ["*"]
  }
}

# Create a new role for EC2 instances 
resource "aws_iam_role" "ec2_manage_elasticip_role" {
  name = var.ec2_manage_elasticip_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = var.ec2_manage_elasticip_role_name
  }
}

# Create an IAM policy for managing elastic IPs and attach it to the role
resource "aws_iam_policy" "elastic_ip_management_policy" {
  name        = "elastic-ip-management-policy"
  description = "Allow EC2 to manage elastic IPs"
  policy      = data.aws_iam_policy_document.ec2_elastic_ip_policy.json

  tags = {
    Name = "elastic-ip-management-policy"
  }
}

# Link the policy to the role
resource "aws_iam_role_policy_attachment" "attach_elastic_ip_policy" {
  role       = aws_iam_role.ec2_manage_elasticip_role.name
  policy_arn = aws_iam_policy.elastic_ip_management_policy.arn
}

# Create an instance profile for EC2 instances
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_manage_elasticip_role.name
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

resource "aws_instance" "rproxymain" {
  for_each = var.rproxymain_configuration
    # AMI of novalys_haproxy built with Packer
    ami           = "ami-0fd91a7fea6b2b38c"
    
    # AWS Free Tier compatible 
    instance_type = "t2.micro"
    security_groups = ["ssh", "httphttps", "8404allow", "vrrp"]
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

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
      role = "rproxymain"
    }
}

resource "aws_instance" "rproxysec" {
  for_each = var.rproxysec_configuration
    # AMI of novalys_haproxy built with Packer
    ami           = "ami-0fd91a7fea6b2b38c"
    
    # AWS Free Tier compatible 
    instance_type = "t2.micro"
    security_groups = ["ssh", "httphttps", "8404allow", "vrrp"]
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

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
      role = "rproxysec"
    }
}
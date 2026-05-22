# Balise de déclaration de notre bloc terraform
terraform {
	# Déclaration de dépendance à un provider depuis le [registre Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest)
  required_providers {
    aws = {
	    # Référence à la page AWS dans le registre
      source = "hashicorp/aws"
      # Version 5.94.1 ou supé. mais sans changement majeur (pas 6.0)
      version = "~> 5.94.1"
    }
  }
    # Version minimum de Terraform CLI
    # required_version = ">= 1.1.0"
}

# Déclaration des paramètres provider pour AWS 
provider "aws" {
    # Nom du profil référencé dans config et credential 
    profile = "gd"
    # Explicite déclaration de la région visé par le déploiement 
    region = "eu-west-3" 
}

# Mention du type de ressource déployer "aws_instance" = "EC2" et son nom 
resource "aws_instance" "first_deployement" {
	# Code AMI de l'ISO (à retrouver sur AWS Console)
	# "ami-0d8423e33dfb7aaea" = "Amazon Linux 2023" 
	# Attention, une clé SSH est à prévoir pour ce déploiement Unix 
  ami           = "ami-0d8423e33dfb7aaea"
  # Type d'instance 
  instance_type = "t2.micro"
  # Choisi des régles de sécurité à appliquer, ici "ssh" pour autoriser le 22 
  # Il faut la créer au préalable dans Console sous le nom "ssh" 
  security_groups = ["ssh"]
  # Décrit la clé à ajouter (celle créée côté Console plus bas) 
  key_name = aws_key_pair.gdpub.key_name

  tags = {
	  # Nom de l'instance côté Console 
    Name = "terraformlearningpath"
  }
}

# Créer une clé côté Console 
resource "aws_key_pair" "gdpub" {
  key_name   = "gd.pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDlImDuGtdxP7fNbWhe1Gp4In0WnwOi1NuhObLGEOVBtr8HbURA7s8fndQBrVSfTQgpRn4JWAQiETm/s5y5D6qQfKwFuKGhrFjHrnm719fl2fuj5DvcM9MINFeGJLoDFh3zv02ieEqC290Yeq+Eqi0lhTQILPXpOaSWp8vzHNV4b1PrY/5sQxsQl3jtLr46EZCUcUorYDpFXVENucVy3oZ61E8Qz3tr0PAkE+TY0TsJh3VDGtI1m6yQHmeJQUsWjt2h8XcNrOjsK0K24L12uA/vAM/YTand0qaWaXT3+78q1to795IVsvW6sdT5v/MsrDDSUBM6gjIQv4KIO40lPKeDPiT9/av6KVAPHRFjYy9uG8TSP3dX/vATkRoVKa3KK+OJzSlaVS0jGjqWE50ir0hAGsBLt0PbtOMHO3cAbeFplxxVnWZjldDVK+4VfiROjhJpD7gy8/FbIg30jYJBdXoLqS+tkOLcTbvFcydDjXOMJD3hF5nXZw0yfFYQGP+gjddVtjxZ3OB69zoXQZefr52JlhRxcUzJxaRMIUx54o/LiQAtNru6KHbrZz/02D/JejmODD4/BCs9iblO7j4RXRCedWNnuMiuZDAgu4JxU4PcrfOiG9sJiNmeRJ0hfKtja48wa34S9FuF8usoi+6dumNrJNqGn1i/vaZiWx45+Jt6Uw=="
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
}

# Génère clé privée + publique
resource "tls_private_key" "mlops_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Crée la KeyPair AWS avec la clé publique
resource "aws_key_pair" "mlops_key" {
  key_name   = var.key_name
  public_key = tls_private_key.mlops_key.public_key_openssh
}

# Sauvegarde la clé privée dans _credentials (au format OpenSSH)
resource "local_file" "mlops_private_key_pem" {
  content              = tls_private_key.mlops_key.private_key_openssh
  filename             = "${path.module}/_credentials/mlops-key.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}

# Donne le VPC par défaut
data "aws_vpc" "default" {
  default = true
}

# Security Group : SSH (22), MLflow (5000), API (8000)
resource "aws_security_group" "mlops_sg" {
  name        = "mlops-sg"
  description = "Allow SSH, API, MLflow"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 1 : mlflow-tracking-training
resource "aws_instance" "mlflow_tracking_training" {
  ami                         = "ami-0fc5d935ebf8bc3bc"
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.mlops_key.key_name
  vpc_security_group_ids      = [aws_security_group.mlops_sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "mlflow-tracking-training"
  }
}

# EC2 2 : api-mlops
resource "aws_instance" "api_mlops" {
  ami                         = "ami-0fc5d935ebf8bc3bc"
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.mlops_key.key_name
  vpc_security_group_ids      = [aws_security_group.mlops_sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "api-mlops"
  }
}

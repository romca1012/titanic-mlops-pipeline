variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_ami" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0c94855ba95c71c99"  # Ubuntu 22.04 LTS
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "SSH key pair name"
  default     = "my-key"
}
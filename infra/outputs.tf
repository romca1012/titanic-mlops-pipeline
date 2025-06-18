output "training_ip" {
  description = "Training instance public IP"
  value       = aws_instance.training.public_ip
}

output "api_ip" {
  description = "API instance public IP"
  value       = aws_instance.api.public_ip
}
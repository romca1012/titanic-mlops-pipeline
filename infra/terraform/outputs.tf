output "mlflow_tracking_training_ip" {
  description = "Public IP of the mlflow-tracking-training instance"
  value       = aws_instance.mlflow_tracking_training.public_ip
}

output "api_mlops_ip" {
  description = "Public IP of the api-mlops instance"
  value       = aws_instance.api_mlops.public_ip
}

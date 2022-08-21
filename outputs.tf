output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.tf-nginx-server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.tf-nginx-server.public_ip
}


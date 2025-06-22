output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.main.public_ip
}

output "private_ip" {
  description = "IP privada de la instancia EC2"
  value       = aws_instance.main.private_ip
}

output "public_dns" {
  description = "DNS público de la instancia EC2"
  value       = aws_instance.main.public_dns
}

output "ami_id" {
  description = "ID de la AMI utilizada"
  value       = aws_instance.main.ami
}

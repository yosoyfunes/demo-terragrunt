output "security_group_id" {
  description = "ID del security group"
  value       = aws_security_group.ec2_sg.id
}

output "security_group_name" {
  description = "Nombre del security group"
  value       = aws_security_group.ec2_sg.name
}

output "security_group_arn" {
  description = "ARN del security group"
  value       = aws_security_group.ec2_sg.arn
}

output "ssh_rule_id" {
  description = "ID de la regla SSH (si está habilitada)"
  value       = var.enable_ssh_access ? aws_security_group_rule.ssh_ingress[0].id : null
}

output "egress_rule_id" {
  description = "ID de la regla de salida (si está habilitada)"
  value       = var.enable_all_egress ? aws_security_group_rule.all_egress[0].id : null
}

output "ssh_enabled" {
  description = "Indica si el acceso SSH está habilitado"
  value       = var.enable_ssh_access
}

output "allowed_ssh_cidrs" {
  description = "CIDRs permitidos para SSH"
  value       = var.enable_ssh_access ? var.allowed_ssh_cidrs : []
}

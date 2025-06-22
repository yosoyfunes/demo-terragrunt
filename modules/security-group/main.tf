# Security Group para instancia EC2
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.project_name}-ec2-sg"
  description = "Security group para instancia EC2 con acceso SSH"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-ec2-sg"
  })
}

# Regla de entrada para SSH (condicional)
resource "aws_security_group_rule" "ssh_ingress" {
  count = var.enable_ssh_access ? 1 : 0
  
  type              = "ingress"
  description       = "SSH access"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidrs
  security_group_id = aws_security_group.ec2_sg.id
}

# Regla de salida - permitir todo el tráfico saliente (condicional)
resource "aws_security_group_rule" "all_egress" {
  count = var.enable_all_egress ? 1 : 0
  
  type              = "egress"
  description       = "All outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}

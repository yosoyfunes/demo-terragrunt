# Incluir configuración global
include "root" {
  path = find_in_parent_folders()
}

# Configuración específica del módulo Security Group para PRODUCCIÓN
terraform {
  source = "../../../modules/security-group"
}

# Dependencias - este módulo necesita que la VPC esté creada primero
dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    vpc_id = "vpc-fake-id"
  }
}

# Variables específicas para este módulo en PRODUCCIÓN
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  
  # Variables específicas del ambiente
  environment = "prod"
  
  # Configuración de acceso SSH para PRODUCCIÓN (más restrictiva)
  enable_ssh_access = true
  ssh_port         = 22
  
  # CRÍTICO: En producción NUNCA usar 0.0.0.0/0
  # Configurar IPs específicas de administradores
  # Ejemplo de IPs corporativas o VPN
  allowed_ssh_cidrs = [
    "203.0.113.0/32",    # IP del administrador 1
    "198.51.100.0/32",   # IP del administrador 2
    # "10.0.0.0/8"       # Red corporativa (si aplica)
  ]
  
  # Configuración de tráfico de salida
  enable_all_egress = true
  
  # Combinar tags base con tags específicos del ambiente
  common_tags = merge(
    # Tags base del archivo raíz
    {
      Project   = "demo-infrastructure"
      ManagedBy = "terragrunt"
    },
    # Tags específicos del ambiente prod
    {
      Environment = "prod"
      CostCenter  = "production"
      Backup      = "required"
      Security    = "high"
      Monitoring  = "enabled"
    }
  )
}

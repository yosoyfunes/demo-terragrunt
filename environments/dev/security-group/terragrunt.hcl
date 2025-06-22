# Incluir configuración global
include "root" {
  path = find_in_parent_folders()
}

# Configuración específica del módulo Security Group
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

# Variables específicas para este módulo en DESARROLLO
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  
  # Variables específicas del ambiente
  environment = "dev"
  
  # Configuración de acceso SSH para DESARROLLO
  enable_ssh_access = true
  ssh_port         = 22
  
  # IMPORTANTE: Cambia esto por tu IP específica para mayor seguridad
  # Ejemplo: ["203.0.113.0/32"] para permitir solo tu IP
  # Para obtener tu IP pública: curl -s https://checkip.amazonaws.com
  allowed_ssh_cidrs = ["0.0.0.0/0"]
  
  # Configuración de tráfico de salida
  enable_all_egress = true
  
  # Combinar tags base con tags específicos del ambiente
  common_tags = merge(
    # Tags base del archivo raíz
    {
      Project   = "demo-infrastructure"
      ManagedBy = "terragrunt"
    },
    # Tags específicos del ambiente dev
    {
      Environment = "dev"
      CostCenter  = "development"
    }
  )
}

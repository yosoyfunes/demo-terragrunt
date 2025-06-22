# Incluir configuración global
include "root" {
  path = find_in_parent_folders()
}

# Configuración específica del módulo VPC para PRODUCCIÓN
terraform {
  source = "../../../modules/vpc"
}

# Variables específicas para este módulo en PRODUCCIÓN
inputs = {
  # Configuración de red para producción (diferente rango que dev)
  vpc_cidr            = "10.1.0.0/16"
  public_subnet_cidr  = "10.1.1.0/24"
  availability_zone   = "us-east-1a"
  
  # Variables específicas del ambiente
  environment = "prod"
  
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
      Monitoring  = "enabled"
    }
  )
}

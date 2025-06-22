# Incluir configuración global
include "root" {
  path = find_in_parent_folders()
}

# Configuración específica del módulo VPC
terraform {
  source = "../../../modules/vpc"
}

# Variables específicas para este módulo en DESARROLLO
inputs = {
  # Configuración de red para desarrollo
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  availability_zone   = "us-east-1a"
  
  # Variables específicas del ambiente
  environment = "dev"
  
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

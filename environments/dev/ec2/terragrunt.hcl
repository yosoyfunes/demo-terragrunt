# Incluir configuración global
include "root" {
  path = find_in_parent_folders()
}

# Configuración específica del módulo EC2
terraform {
  source = "../../../modules/ec2"
}

# Dependencias - este módulo necesita VPC y Security Group
dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    public_subnet_id = "subnet-fake-id"
  }
}

dependency "security_group" {
  config_path = "../security-group"
  
  mock_outputs = {
    security_group_id = "sg-fake-id"
  }
}

# Variables específicas para este módulo en DESARROLLO
inputs = {
  # Configuración de la instancia para desarrollo
  instance_type     = "t2.micro"
  subnet_id         = dependency.vpc.outputs.public_subnet_id
  security_group_id = dependency.security_group.outputs.security_group_id
  
  # Variables específicas del ambiente
  environment = "dev"
  
  # OPCIONAL: Especifica el nombre de tu clave SSH existente en AWS
  # Si no tienes una clave, comenta esta línea o déjala como null
  key_name = null  # Cambia por el nombre de tu clave SSH, ej: "mi-clave-ssh"
  
  # OPCIONAL: Script de inicialización básico para desarrollo
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y htop
    echo "Instancia EC2 de DESARROLLO configurada correctamente" > /tmp/setup-complete.txt
    echo "DEVELOPMENT" > /etc/environment-type
  EOF
  
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

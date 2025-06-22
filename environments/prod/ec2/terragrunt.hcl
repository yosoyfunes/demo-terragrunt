# Incluir configuración global
include "root" {
  path = find_in_parent_folders()
}

# Configuración específica del módulo EC2 para PRODUCCIÓN
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

# Variables específicas para este módulo en PRODUCCIÓN
inputs = {
  # Configuración de la instancia para producción (más potente que dev)
  instance_type     = "t3.small"
  subnet_id         = dependency.vpc.outputs.public_subnet_id
  security_group_id = dependency.security_group.outputs.security_group_id
  
  # Variables específicas del ambiente
  environment = "prod"
  
  # IMPORTANTE: Especifica el nombre de tu clave SSH para producción
  # Usa una clave diferente y más segura para producción
  key_name = null  # Cambia por "prod-key-ssh" o similar
  
  # Script de inicialización avanzado para producción
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    
    # Instalar herramientas de monitoreo y seguridad
    yum install -y htop iotop nethogs
    yum install -y fail2ban
    
    # Configurar timezone
    timedatectl set-timezone America/Argentina/Buenos_Aires
    
    # Habilitar servicios de seguridad
    systemctl enable fail2ban
    systemctl start fail2ban
    
    # Configurar logs
    echo "$(date): Instancia EC2 de PRODUCCIÓN configurada" >> /var/log/setup.log
    
    # Crear archivo de identificación del ambiente
    echo "PRODUCTION" > /etc/environment-type
    
    # Configurar actualizaciones automáticas de seguridad
    yum install -y yum-cron
    systemctl enable yum-cron
    systemctl start yum-cron
  EOF
  
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
      Security    = "high"
    }
  )
}

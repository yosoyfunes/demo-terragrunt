# Configuración global de Terragrunt
remote_state {
  backend = "s3"
  config = {
    bucket         = "demo-terraform-state-${get_env("USER", "default")}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Variables globales que se pasarán a todos los módulos
# NOTA: Los valores específicos del ambiente (como environment) 
# se definen en cada archivo terragrunt.hcl del ambiente correspondiente
inputs = {
  aws_region   = "us-east-1"
  project_name = "demo-infrastructure"
  
  # Tags base comunes (se pueden extender en cada ambiente)
  base_tags = {
    Project   = "demo-infrastructure"
    ManagedBy = "terragrunt"
  }
}

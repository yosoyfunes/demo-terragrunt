# Configuración global de Terragrunt
# remote_state {
#   backend = "s3"
#   config = {
#     bucket         = "demo-terraform-state-${get_env("USER", "default")}"
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#     region         = get_env("AWS_DEFAULT_REGION", "us-east-1")
#     encrypt        = true
#     dynamodb_table = "terraform-locks"

#     # Configuraciones para LocalStack unicamente
#     endpoint                            = "http://localhost.localstack.cloud:4566"    
#     skip_bucket_lifecycle               = true
#     skip_bucket_public_access_blocking  = true
#     skip_bucket_versioning              = true # use only if the object store does not support versioning
#     skip_bucket_ssencryption            = true # use only if non-encrypted OpenTofu/Terraform State is required and/or the object store does not support server-side encryption
#     skip_bucket_root_access             = true # use only if the AWS account root user should not have access to the remote state bucket for some reason
#     skip_bucket_enforced_tls            = true # use only if you need to access the S3 bucket without TLS being enforced
#     skip_credentials_validation         = true # skip validation of AWS credentials, useful when is used S3 compatible object store different from AWS
#     enable_lock_table_ssencryption      = true # use only if non-encrypted DynamoDB Lock Table for the OpenTofu/Terraform State is required and/or the NoSQL database service does not support server-side encryption

#     skip_metadata_api_check     = true
#     force_path_style            = true
#   }

#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
# }

remote_state {
  backend = "local"
  config = {    
    path = "${get_terragrunt_dir()}/${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform {
  # plan should not lock, for local and pipeline, so pipelines do not compete for the lock
  extra_arguments "plan_no_lock" {
    commands  = ["plan"]
    arguments = ["-lock=false"]
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

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#generate
# copy global variable definitions to terragrunt run dir
generate "global_variables" {
  path      = "global_variables.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("globals/variables.tf")
}

generate "provider" {
  path      = "global_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("globals/provider.tf")
}
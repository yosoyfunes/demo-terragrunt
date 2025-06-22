variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nombre de la clave SSH (opcional)"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "ID de la subred donde crear la instancia"
  type        = string
}

variable "security_group_id" {
  description = "ID del security group para la instancia"
  type        = string
}

variable "user_data" {
  description = "Script de user data para la instancia (opcional)"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default     = {}
}

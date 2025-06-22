variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde crear el security group"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "Lista de CIDRs permitidos para acceso SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_port" {
  description = "Puerto para acceso SSH"
  type        = number
  default     = 22
}

variable "enable_ssh_access" {
  description = "Habilitar regla de acceso SSH"
  type        = bool
  default     = true
}

variable "enable_all_egress" {
  description = "Habilitar regla de salida para todo el tráfico"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default     = {}
}

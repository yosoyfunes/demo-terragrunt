# Ejemplo de configuración avanzada del Security Group
# Este archivo muestra diferentes opciones de configuración

# Configuración básica con SSH habilitado
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  
  # Habilitar acceso SSH
  enable_ssh_access = true
  ssh_port         = 22
  allowed_ssh_cidrs = ["203.0.113.0/32"]  # Solo tu IP específica
  
  # Habilitar tráfico de salida
  enable_all_egress = true
}

# Configuración sin SSH (más segura)
# inputs = {
#   vpc_id = dependency.vpc.outputs.vpc_id
#   
#   # Deshabilitar acceso SSH
#   enable_ssh_access = false
#   
#   # Habilitar tráfico de salida
#   enable_all_egress = true
# }

# Configuración con puerto SSH personalizado
# inputs = {
#   vpc_id = dependency.vpc.outputs.vpc_id
#   
#   # SSH en puerto personalizado
#   enable_ssh_access = true
#   ssh_port         = 2222
#   allowed_ssh_cidrs = ["203.0.113.0/32", "198.51.100.0/32"]
#   
#   # Habilitar tráfico de salida
#   enable_all_egress = true
# }

# Configuración restrictiva (sin reglas automáticas)
# inputs = {
#   vpc_id = dependency.vpc.outputs.vpc_id
#   
#   # Sin reglas automáticas - se pueden agregar manualmente después
#   enable_ssh_access = false
#   enable_all_egress = false
# }

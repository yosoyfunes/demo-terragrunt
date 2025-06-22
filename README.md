# Infraestructura AWS con Terragrunt y Terraform

Este proyecto implementa una infraestructura básica en AWS utilizando Terragrunt para la gestión de configuraciones y Terraform para el aprovisionamiento de recursos.

## Arquitectura

La infraestructura incluye:
- **VPC** con una subred pública
- **Instancia EC2** t2.micro con acceso SSH
- **Security Group** con reglas flexibles usando `aws_security_group_rule`
- **Internet Gateway** para conectividad a internet
- **Route Table** para enrutamiento público

## Estructura del Proyecto

```
demo-terragrunt/
├── README.md
├── terragrunt.hcl                 # Configuración global de Terragrunt
├── modules/                       # Módulos de Terraform reutilizables
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security-group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/                  # Configuraciones por ambiente
│   ├── dev/                       # Ambiente de desarrollo
│   │   ├── vpc/
│   │   │   └── terragrunt.hcl
│   │   ├── security-group/
│   │   │   └── terragrunt.hcl
│   │   └── ec2/
│   │       └── terragrunt.hcl
│   └── prod/                      # Ambiente de producción
│       ├── vpc/
│       │   └── terragrunt.hcl
│       ├── security-group/
│       │   └── terragrunt.hcl
│       └── ec2/
│           └── terragrunt.hcl
├── scripts/                       # Scripts de automatización
│   ├── setup.sh
│   ├── cleanup.sh
│   ├── get-my-ip.sh
│   └── deploy-environment.sh
├── docs/                          # Documentación adicional
│   └── environments-comparison.md
└── examples/                      # Ejemplos de configuración
    └── security-group-advanced.hcl
```

## Prerrequisitos

1. **AWS CLI** configurado con credenciales válidas
2. **Terraform** >= 1.0
3. **Terragrunt** >= 0.45
4. **Clave SSH** existente en AWS (opcional)

### Instalación de herramientas

```bash
# Terraform
brew install terraform

# Terragrunt
brew install terragrunt

# AWS CLI
brew install awscli
```

### Configuración de AWS

```bash
aws configure
# Ingresa tu Access Key ID, Secret Access Key, región por defecto, etc.
```

## Características del Módulo Security Group

El módulo de Security Group utiliza recursos `aws_security_group_rule` separados para mayor flexibilidad:

### Ventajas de usar `aws_security_group_rule`

- **Flexibilidad**: Permite agregar/quitar reglas sin recrear el Security Group
- **Evita conflictos**: Previene el error "rule already exists" 
- **Gestión granular**: Cada regla se gestiona independientemente
- **Configuración condicional**: Reglas opcionales basadas en variables

### Variables de configuración

```hcl
# Habilitar/deshabilitar acceso SSH
enable_ssh_access = true

# Puerto SSH personalizado
ssh_port = 22

# IPs permitidas para SSH
allowed_ssh_cidrs = ["203.0.113.0/32"]

# Habilitar/deshabilitar tráfico de salida
enable_all_egress = true
```

### Ejemplos de uso

Ver `examples/security-group-advanced.hcl` para configuraciones avanzadas.

## Configuración

### 1. Variables Globales

El archivo `terragrunt.hcl` en la raíz contiene la configuración global:

```hcl
# Configuración del backend remoto para el estado de Terraform
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

# Variables globales (NO incluye environment - se define por ambiente)
inputs = {
  aws_region   = "us-east-1"
  project_name = "demo-infrastructure"
  
  # Tags base comunes (se extienden en cada ambiente)
  base_tags = {
    Project   = "demo-infrastructure"
    ManagedBy = "terragrunt"
  }
}
```

**Importante**: Las variables específicas del ambiente (como `environment`) se definen en cada archivo `terragrunt.hcl` del ambiente correspondiente, no en el archivo raíz.

### 2. Personalización

Antes de desplegar, personaliza las siguientes variables en los archivos `terragrunt.hcl`:

- **Región AWS**: Cambia `aws_region` en el archivo raíz
- **Nombre del proyecto**: Modifica `project_name`
- **Clave SSH**: Especifica `key_name` en `environments/dev/ec2/terragrunt.hcl`
- **Bucket S3**: Actualiza el nombre del bucket para el estado remoto

## Despliegue

### Opción 1: Script automatizado por ambiente (recomendado)

```bash
# Desarrollo
./scripts/deploy-environment.sh dev init
./scripts/deploy-environment.sh dev plan
./scripts/deploy-environment.sh dev apply

# Producción (requiere confirmación adicional)
./scripts/deploy-environment.sh prod init
./scripts/deploy-environment.sh prod plan
./scripts/deploy-environment.sh prod apply
```

### Opción 2: Despliegue completo con run-all

```bash
# Para desarrollo
cd environments/dev
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply

# Para producción
cd environments/prod
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
```

### Opción 3: Despliegue por módulos

```bash
# Ejemplo para desarrollo
cd environments/dev

# 1. Desplegar VPC primero
cd vpc
terragrunt init
terragrunt plan
terragrunt apply

# 2. Desplegar Security Group
cd ../security-group
terragrunt init
terragrunt plan
terragrunt apply

# 3. Desplegar instancia EC2
cd ../ec2
terragrunt init
terragrunt plan
terragrunt apply
```

## Ambientes Disponibles

### 🔧 Desarrollo (dev)
- **Propósito**: Pruebas y desarrollo
- **Instancia**: t2.micro (Free Tier)
- **Seguridad**: SSH abierto (menos restrictivo)
- **Red**: 10.0.0.0/16

### 🏭 Producción (prod)
- **Propósito**: Cargas de trabajo de producción
- **Instancia**: t3.small (más potente)
- **Seguridad**: SSH restringido a IPs específicas
- **Red**: 10.1.0.0/16
- **Extras**: Fail2ban, monitoreo, actualizaciones automáticas

Ver `docs/environments-comparison.md` para comparación detallada.

## Conexión a la instancia EC2

Una vez desplegada la infraestructura, puedes conectarte a la instancia EC2:

```bash
# Obtener la IP pública de la instancia
cd environments/dev/ec2
terragrunt output public_ip

# Conectarse por SSH (si configuraste una clave)
ssh -i ~/.ssh/tu-clave-privada.pem ec2-user@<IP_PUBLICA>
```

## Outputs Importantes

Después del despliegue, obtendrás los siguientes outputs:

- **VPC ID**: ID de la VPC creada
- **Subnet ID**: ID de la subred pública
- **Security Group ID**: ID del security group
- **Instance ID**: ID de la instancia EC2
- **Public IP**: IP pública de la instancia EC2

## Limpieza de Recursos

Para destruir toda la infraestructura:

```bash
cd environments/dev

# Opción 1: Destruir todo de una vez
terragrunt run-all destroy

# Opción 2: Destruir en orden inverso (recomendado)
cd ec2 && terragrunt destroy
cd ../security-group && terragrunt destroy
cd ../vpc && terragrunt destroy
```

## Costos Estimados

Los recursos desplegados tienen los siguientes costos aproximados (región us-east-1):

- **VPC, Subnet, IGW, Route Table**: Gratis
- **Security Group**: Gratis
- **Instancia EC2 t2.micro**: ~$8.50/mes (elegible para Free Tier)

> **Nota**: Los costos pueden variar según la región y el uso. Usa la [Calculadora de Precios de AWS](https://calculator.aws) para estimaciones precisas.

## Seguridad

### Mejores Prácticas Implementadas

- Security Group con acceso SSH restringido
- Subred pública solo para recursos que necesitan acceso a internet
- Cifrado habilitado para el estado de Terraform en S3

### Recomendaciones Adicionales

- Restringe el acceso SSH a IPs específicas en lugar de 0.0.0.0/0
- Considera usar AWS Systems Manager Session Manager en lugar de SSH directo
- Implementa rotación de claves SSH regularmente
- Usa IAM roles en lugar de credenciales hardcodeadas

## Troubleshooting

### Errores Comunes

1. **Error de credenciales AWS**:
   ```bash
   aws sts get-caller-identity
   ```

2. **Bucket S3 no existe**:
   - Crea el bucket manualmente o actualiza la configuración

3. **Clave SSH no encontrada**:
   - Verifica que la clave existe en la consola de AWS EC2

4. **Conflictos de estado**:
   ```bash
   terragrunt force-unlock <LOCK_ID>
   ```

## Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crea un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## Contacto

Para preguntas o soporte, contacta al equipo de infraestructura.

# Changelog - Demo Terragrunt Infrastructure

## [1.1.0] - 2024-06-22

### ✅ Fixed - Variables Globales Corregidas

**Problema identificado**: El archivo `terragrunt.hcl` raíz tenía hardcodeado `environment = "dev"`, lo cual era incorrecto para una infraestructura multi-ambiente.

### 🔧 Cambios Realizados

#### Archivo Raíz (`terragrunt.hcl`)
- ❌ **Antes**: Contenía `environment = "dev"` hardcodeado
- ✅ **Ahora**: Solo contiene variables verdaderamente globales
- ✅ **Nuevo**: `base_tags` en lugar de `common_tags` hardcodeados

#### Variables por Ambiente
- ✅ **Dev**: `environment = "dev"` definido en cada módulo del ambiente
- ✅ **Prod**: `environment = "prod"` definido en cada módulo del ambiente
- ✅ **Tags**: Cada ambiente combina `base_tags` + tags específicos del ambiente

#### Estructura de Tags Mejorada
```hcl
# Antes (incorrecto)
common_tags = {
  Project     = "demo-infrastructure"
  Environment = "dev"  # ❌ Hardcodeado en archivo global
  ManagedBy   = "terragrunt"
}

# Ahora (correcto)
common_tags = merge(
  # Tags base del archivo raíz
  {
    Project   = "demo-infrastructure"
    ManagedBy = "terragrunt"
  },
  # Tags específicos del ambiente
  {
    Environment = "dev"  # ✅ Definido por ambiente
    CostCenter  = "development"
  }
)
```

### 🆕 Nuevas Características

#### Script de Validación
- ✅ `scripts/validate-config.sh` - Valida configuración de ambientes
- ✅ Verifica que no haya variables hardcodeadas incorrectamente
- ✅ Confirma que cada ambiente tenga su `environment` correcto

#### Documentación Actualizada
- ✅ README.md actualizado con explicación de variables globales
- ✅ Ejemplos corregidos en la documentación
- ✅ Clarificación sobre separación de variables por ambiente

### 🔍 Validación

Ejecutar para verificar la configuración:
```bash
./scripts/validate-config.sh
```

### 📋 Estructura Final de Variables

```
terragrunt.hcl (raíz)
├── aws_region = "us-east-1"           # ✅ Global
├── project_name = "demo-infrastructure" # ✅ Global
└── base_tags = { ... }                # ✅ Global

environments/dev/*/terragrunt.hcl
├── environment = "dev"                # ✅ Específico de dev
└── common_tags = merge(base_tags, dev_tags)

environments/prod/*/terragrunt.hcl
├── environment = "prod"               # ✅ Específico de prod
└── common_tags = merge(base_tags, prod_tags)
```

### 🎯 Beneficios

1. **Separación correcta**: Variables globales vs específicas de ambiente
2. **Escalabilidad**: Fácil agregar nuevos ambientes (staging, qa, etc.)
3. **Mantenibilidad**: Cambios globales en un solo lugar
4. **Flexibilidad**: Cada ambiente puede tener configuración específica
5. **Validación**: Script automático para verificar configuración

### 🚀 Próximos Pasos

1. Ejecutar validación: `./scripts/validate-config.sh`
2. Personalizar IPs en producción
3. Configurar claves SSH específicas por ambiente
4. Desplegar ambientes por separado

---

## [1.0.0] - 2024-06-22

### 🎉 Lanzamiento Inicial

- ✅ Infraestructura básica con VPC, Security Group, EC2
- ✅ Módulos de Terraform reutilizables
- ✅ Configuración de Terragrunt por ambientes
- ✅ Security Group con `aws_security_group_rule` separados
- ✅ Scripts de automatización
- ✅ Documentación completa

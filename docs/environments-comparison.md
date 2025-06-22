# Comparación de Ambientes: Dev vs Prod

Este documento describe las diferencias entre los ambientes de desarrollo y producción.

## 🏗️ Arquitectura General

Ambos ambientes tienen la misma arquitectura básica:
- VPC con subred pública
- Security Group con reglas SSH
- Instancia EC2
- Internet Gateway y Route Table

## 🔧 Diferencias de Configuración

### VPC y Networking

| Componente | Desarrollo (dev) | Producción (prod) |
|------------|------------------|-------------------|
| VPC CIDR | `10.0.0.0/16` | `10.1.0.0/16` |
| Subred Pública | `10.0.1.0/24` | `10.1.1.0/24` |
| Zona de Disponibilidad | `us-east-1a` | `us-east-1a` |

### Security Group

| Configuración | Desarrollo (dev) | Producción (prod) |
|---------------|------------------|-------------------|
| SSH Habilitado | ✅ Sí | ✅ Sí |
| Puerto SSH | 22 | 22 |
| IPs Permitidas | `0.0.0.0/0` (⚠️ Abierto) | IPs específicas (🔒 Restringido) |
| Tráfico de Salida | Permitido | Permitido |

### Instancias EC2

| Configuración | Desarrollo (dev) | Producción (prod) |
|---------------|------------------|-------------------|
| Tipo de Instancia | `t2.micro` | `t3.small` |
| Clave SSH | Opcional | Requerida (diferente) |
| User Data | Básico | Avanzado con seguridad |
| Monitoreo | Básico | Habilitado |

### Tags y Metadatos

| Tag | Desarrollo (dev) | Producción (prod) |
|-----|------------------|-------------------|
| Environment | `dev` | `prod` |
| CostCenter | - | `production` |
| Backup | - | `required` |
| Security | - | `high` |
| Monitoring | - | `enabled` |

## 🛡️ Configuraciones de Seguridad

### Desarrollo
- SSH abierto desde cualquier IP (para facilitar desarrollo)
- Instancia básica sin herramientas adicionales
- Sin configuraciones especiales de seguridad

### Producción
- SSH restringido a IPs específicas de administradores
- Fail2ban instalado y configurado
- Actualizaciones automáticas de seguridad
- Logs de configuración
- Timezone configurado
- Herramientas de monitoreo instaladas

## 💰 Costos Estimados (us-east-1)

### Desarrollo
- **VPC, Subnet, IGW, Route Table**: Gratis
- **Security Group**: Gratis
- **EC2 t2.micro**: ~$8.50/mes (Free Tier elegible)
- **Total**: ~$8.50/mes

### Producción
- **VPC, Subnet, IGW, Route Table**: Gratis
- **Security Group**: Gratis
- **EC2 t3.small**: ~$15.18/mes
- **Total**: ~$15.18/mes

## 🚀 Comandos de Despliegue

### Desarrollo
```bash
# Desplegar desarrollo
./scripts/deploy-environment.sh dev init
./scripts/deploy-environment.sh dev plan
./scripts/deploy-environment.sh dev apply

# Ver outputs
./scripts/deploy-environment.sh dev output
```

### Producción
```bash
# Desplegar producción (requiere confirmación adicional)
./scripts/deploy-environment.sh prod init
./scripts/deploy-environment.sh prod plan
./scripts/deploy-environment.sh prod apply  # Requiere escribir 'PROD'

# Ver outputs
./scripts/deploy-environment.sh prod output
```

## 📋 Checklist Pre-Despliegue

### Desarrollo ✅
- [ ] AWS CLI configurado
- [ ] Bucket S3 para estado remoto creado
- [ ] Variables personalizadas ajustadas

### Producción ⚠️
- [ ] AWS CLI configurado con credenciales de producción
- [ ] Bucket S3 para estado remoto creado (diferente al de dev)
- [ ] Clave SSH de producción creada en AWS
- [ ] IPs de administradores identificadas y configuradas
- [ ] Aprobación del equipo de seguridad
- [ ] Plan de rollback definido
- [ ] Monitoreo configurado
- [ ] Backup strategy definida

## 🔄 Promoción de Cambios

1. **Desarrollo**: Probar cambios en ambiente dev
2. **Validación**: Verificar que todo funciona correctamente
3. **Code Review**: Revisar código y configuraciones
4. **Producción**: Aplicar cambios en prod con precaución

## 🆘 Troubleshooting por Ambiente

### Problemas Comunes en Dev
- Conflictos de IP con otros desarrolladores
- Estado de Terraform corrupto por experimentos

### Problemas Comunes en Prod
- Acceso SSH bloqueado por cambio de IP
- Recursos compartidos con otros sistemas
- Impacto en usuarios finales

## 📞 Contactos de Emergencia

- **Desarrollo**: Equipo de desarrollo
- **Producción**: Equipo de SRE/DevOps + Gerencia técnica

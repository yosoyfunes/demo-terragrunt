#!/bin/bash

# Script para desplegar un ambiente específico (dev o prod)

set -e

# Función para mostrar ayuda
show_help() {
    echo "🚀 Script de despliegue por ambiente"
    echo ""
    echo "Uso: $0 <ambiente> <acción>"
    echo ""
    echo "Ambientes disponibles:"
    echo "  dev   - Ambiente de desarrollo"
    echo "  prod  - Ambiente de producción"
    echo ""
    echo "Acciones disponibles:"
    echo "  init     - Inicializar Terraform"
    echo "  plan     - Mostrar plan de ejecución"
    echo "  apply    - Aplicar cambios"
    echo "  destroy  - Destruir recursos"
    echo "  output   - Mostrar outputs"
    echo ""
    echo "Ejemplos:"
    echo "  $0 dev init"
    echo "  $0 dev plan"
    echo "  $0 dev apply"
    echo "  $0 prod plan"
    echo "  $0 prod apply"
}

# Verificar parámetros
if [ $# -ne 2 ]; then
    show_help
    exit 1
fi

ENVIRONMENT=$1
ACTION=$2

# Validar ambiente
if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "prod" ]]; then
    echo "❌ Ambiente inválido: $ENVIRONMENT"
    echo "   Ambientes válidos: dev, prod"
    exit 1
fi

# Validar acción
if [[ "$ACTION" != "init" && "$ACTION" != "plan" && "$ACTION" != "apply" && "$ACTION" != "destroy" && "$ACTION" != "output" ]]; then
    echo "❌ Acción inválida: $ACTION"
    echo "   Acciones válidas: init, plan, apply, destroy, output"
    exit 1
fi

# Directorio del ambiente
ENV_DIR="$(dirname "$0")/../environments/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
    echo "❌ Directorio del ambiente no existe: $ENV_DIR"
    exit 1
fi

echo "🌍 Ambiente: $ENVIRONMENT"
echo "⚡ Acción: $ACTION"
echo "📁 Directorio: $ENV_DIR"
echo ""

# Advertencia especial para producción
if [[ "$ENVIRONMENT" == "prod" ]]; then
    echo "⚠️  ADVERTENCIA: Estás trabajando en el ambiente de PRODUCCIÓN"
    echo ""
    
    if [[ "$ACTION" == "apply" || "$ACTION" == "destroy" ]]; then
        echo "🔴 Esta acción modificará recursos de PRODUCCIÓN"
        read -p "¿Estás seguro de que quieres continuar? (escribe 'PROD' para confirmar): " confirm
        
        if [ "$confirm" != "PROD" ]; then
            echo "❌ Operación cancelada"
            exit 1
        fi
    fi
fi

cd "$ENV_DIR"

# Ejecutar la acción
case $ACTION in
    "init")
        echo "🔧 Inicializando $ENVIRONMENT..."
        terragrunt run-all init
        ;;
    "plan")
        echo "📋 Planificando $ENVIRONMENT..."
        terragrunt run-all plan
        ;;
    "apply")
        echo "🚀 Aplicando cambios en $ENVIRONMENT..."
        terragrunt run-all apply
        ;;
    "destroy")
        echo "🗑️  Destruyendo recursos en $ENVIRONMENT..."
        echo "⚠️  Esta acción eliminará TODOS los recursos del ambiente $ENVIRONMENT"
        read -p "¿Estás seguro? (escribe 'yes' para confirmar): " confirm
        
        if [ "$confirm" != "yes" ]; then
            echo "❌ Operación cancelada"
            exit 1
        fi
        
        terragrunt run-all destroy
        ;;
    "output")
        echo "📊 Outputs del ambiente $ENVIRONMENT:"
        echo ""
        echo "=== VPC ==="
        cd vpc && terragrunt output 2>/dev/null || echo "No hay outputs disponibles"
        echo ""
        echo "=== Security Group ==="
        cd ../security-group && terragrunt output 2>/dev/null || echo "No hay outputs disponibles"
        echo ""
        echo "=== EC2 ==="
        cd ../ec2 && terragrunt output 2>/dev/null || echo "No hay outputs disponibles"
        ;;
esac

echo ""
echo "✅ Acción '$ACTION' completada para el ambiente '$ENVIRONMENT'"

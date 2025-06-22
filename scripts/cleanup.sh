#!/bin/bash

# Script para limpiar la infraestructura desplegada

set -e

echo "🧹 Iniciando limpieza de la infraestructura..."

cd "$(dirname "$0")/../environments/dev"

echo "⚠️  ADVERTENCIA: Este script destruirá TODA la infraestructura desplegada."
echo "   Esto incluye:"
echo "   - Instancia EC2"
echo "   - Security Group"
echo "   - VPC, Subnets, Internet Gateway, Route Tables"
echo ""

read -p "¿Estás seguro de que quieres continuar? (escribe 'yes' para confirmar): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Operación cancelada"
    exit 1
fi

echo ""
echo "🗑️  Destruyendo recursos en orden inverso..."

# Destruir EC2 primero
echo "1️⃣  Destruyendo instancia EC2..."
cd ec2
terragrunt destroy -auto-approve
cd ..

# Destruir Security Group
echo "2️⃣  Destruyendo Security Group..."
cd security-group
terragrunt destroy -auto-approve
cd ..

# Destruir VPC al final
echo "3️⃣  Destruyendo VPC y recursos de red..."
cd vpc
terragrunt destroy -auto-approve
cd ..

echo ""
echo "✅ ¡Limpieza completada!"
echo "   Todos los recursos han sido destruidos."

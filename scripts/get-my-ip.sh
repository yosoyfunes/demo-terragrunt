#!/bin/bash

# Script para obtener tu IP pública y generar configuración de Security Group

echo "🌐 Obteniendo tu IP pública..."

# Obtener IP pública usando diferentes servicios
IP1=$(curl -s https://checkip.amazonaws.com 2>/dev/null)
IP2=$(curl -s https://ipinfo.io/ip 2>/dev/null)
IP3=$(curl -s https://api.ipify.org 2>/dev/null)

# Verificar que obtuvimos una IP válida
if [[ $IP1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    MY_IP=$IP1
elif [[ $IP2 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    MY_IP=$IP2
elif [[ $IP3 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    MY_IP=$IP3
else
    echo "❌ No se pudo obtener la IP pública"
    exit 1
fi

echo "✅ Tu IP pública es: $MY_IP"
echo ""
echo "📋 Configuración recomendada para Security Group:"
echo ""
echo "allowed_ssh_cidrs = [\"$MY_IP/32\"]"
echo ""
echo "💡 Copia esta línea en tu archivo:"
echo "   environments/dev/security-group/terragrunt.hcl"
echo ""
echo "⚠️  Nota: Esta IP puede cambiar si reinicias tu router o cambias de ubicación."

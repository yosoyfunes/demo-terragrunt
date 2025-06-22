#!/bin/bash

# Script de configuración inicial para el proyecto demo-terragrunt

set -e

echo "🚀 Configurando proyecto demo-terragrunt..."

# Verificar herramientas necesarias
echo "📋 Verificando herramientas necesarias..."

if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform no está instalado. Instálalo con: brew install terraform"
    exit 1
fi

if ! command -v terragrunt &> /dev/null; then
    echo "❌ Terragrunt no está instalado. Instálalo con: brew install terragrunt"
    exit 1
fi

if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI no está instalado. Instálalo con: brew install awscli"
    exit 1
fi

echo "✅ Todas las herramientas están instaladas"

# Verificar configuración de AWS
echo "🔐 Verificando configuración de AWS..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS CLI no está configurado correctamente"
    echo "   Ejecuta: aws configure"
    exit 1
fi

echo "✅ AWS CLI configurado correctamente"

# Mostrar información de la cuenta AWS
echo "📊 Información de la cuenta AWS:"
aws sts get-caller-identity

echo ""
echo "🎉 ¡Configuración completada!"
echo ""
echo "📝 Próximos pasos:"
echo "1. Revisa y personaliza las variables en terragrunt.hcl"
echo "2. Actualiza el nombre del bucket S3 para el estado remoto"
echo "3. Si tienes una clave SSH, actualiza key_name en environments/dev/ec2/terragrunt.hcl"
echo "4. Ejecuta el despliegue:"
echo "   cd environments/dev"
echo "   terragrunt run-all init"
echo "   terragrunt run-all plan"
echo "   terragrunt run-all apply"

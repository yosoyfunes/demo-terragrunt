#!/bin/bash

# Script para validar la configuración de ambientes

set -e

echo "🔍 Validando configuración de ambientes..."
echo ""

# Función para validar un ambiente
validate_environment() {
    local env=$1
    local env_dir="$(dirname "$0")/../environments/$env"
    
    echo "📋 Validando ambiente: $env"
    
    if [ ! -d "$env_dir" ]; then
        echo "❌ Directorio del ambiente no existe: $env_dir"
        return 1
    fi
    
    # Verificar que existan los archivos de configuración
    local modules=("vpc" "security-group" "ec2")
    for module in "${modules[@]}"; do
        local config_file="$env_dir/$module/terragrunt.hcl"
        if [ ! -f "$config_file" ]; then
            echo "❌ Archivo de configuración faltante: $config_file"
            return 1
        fi
        
        # Verificar que el archivo contenga la variable environment correcta
        if ! grep -q "environment = \"$env\"" "$config_file"; then
            echo "❌ Variable 'environment' incorrecta en: $config_file"
            echo "   Debería ser: environment = \"$env\""
            return 1
        fi
        
        echo "✅ $module: OK"
    done
    
    echo "✅ Ambiente $env: Configuración válida"
    echo ""
}

# Validar archivo raíz
echo "📋 Validando archivo raíz terragrunt.hcl..."
root_file="$(dirname "$0")/../terragrunt.hcl"

if [ ! -f "$root_file" ]; then
    echo "❌ Archivo raíz no existe: $root_file"
    exit 1
fi

# Verificar que NO contenga environment hardcodeado
if grep -q "environment.*=" "$root_file" && ! grep -q "# se definen en cada archivo" "$root_file"; then
    echo "❌ El archivo raíz contiene 'environment' hardcodeado"
    echo "   Las variables de ambiente deben definirse en cada ambiente específico"
    exit 1
fi

echo "✅ Archivo raíz: OK"
echo ""

# Validar ambientes
validate_environment "dev"
validate_environment "prod"

echo "🎉 ¡Validación completada exitosamente!"
echo ""
echo "📊 Resumen de configuración:"
echo "├── Archivo raíz: Variables globales sin environment hardcodeado"
echo "├── Ambiente dev: environment = \"dev\""
echo "└── Ambiente prod: environment = \"prod\""
echo ""
echo "✅ La configuración está correcta para múltiples ambientes"

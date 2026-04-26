#!/bin/bash

# 1. Configuración
RAMA="main"
MENSAJE="Actualizada $(basename "$PWD") : $(date +'%d-%m-%Y')"

# 2. Ir a la raíz del proyecto
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT/../" || exit

echo "========================================" 
echo "  Preparar FacturasApp para publicación "
echo "========================================"
echo

# 3. VERIFICACIÓN: ¿Hay cambios reales?
echo "🔍 Paso 1: Verificando cambios..."
echo ""

cd "$REPO_ROOT"
# 'git status --porcelain' devuelve texto si hay cambios, o nada si está limpio.
if [[ -z $(git status --porcelain) ]]; then
    echo "✨ Todo está al día. No hay cambios para subir."
    echo
    read -p "ENTER para finalizar..." e
    exit 0
fi

# 4. Si llegamos aquí, es que hay cambios
echo "✓ Detectados cambios"
echo ""
echo "🛠️  Paso 2: Procesando cambios..."
echo ""

# 5. Ejecución silenciosa
git add .

# Intentar hacer amend para no llenar el log, o commit si es el primero
if git commit --amend -m "$MENSAJE" > /dev/null 2>&1; then
    echo "✓ Commit actualizado (amend)"
else
    git commit -m "$MENSAJE" > /dev/null 2>&1
    echo "✓ Nuevo commit creado"
fi

echo ""
echo "🚀 Paso 3: Subiendo a GitHub..."
echo ""

git push origin $RAMA --force > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ ¡Actualización completada con éxito!"
    echo ""
    echo "   Rama: $RAMA"
    echo "   Mensaje: $MENSAJE"
    echo ""
else
    echo "✗ ERROR: Falló el push a GitHub"
    read -p "ENTER para finalizar..." e
    exit 1
fi

echo
read -p "ENTER para finalizar..." e


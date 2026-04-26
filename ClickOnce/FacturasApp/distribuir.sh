#!/bin/bash

# 1. Configuración
RAMA="main"
MENSAJE="Actualizada $(basename "$PWD") : $(date +'%d-%m-%Y')"

# 2. Ir a la raíz del repositorio
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT" || exit

# 3. VERIFICACIÓN: ¿Hay cambios reales?
# 'git status --porcelain' devuelve texto si hay cambios, o nada si está limpio.
if [[ -z $(git status --porcelain) ]]; then
    echo "✨ Todo está al día. No hay cambios para subir."
    read -p "ENTER para finalizar..." e
    exit 0
fi

# 4. Si llegamos aquí, es que hay cambios
echo "🛠️  Detectados cambios en $(basename "$PWD"). Actualizando..."

# 5. Ejecución silenciosa
git add .

# Intentar hacer amend para no llenar el log, o commit si es el primero
git commit --amend -m "$MENSAJE" > /dev/null || git commit -m "$MENSAJE" > /dev/null

echo "🚀 Subiendo a GitHub..."
git push origin $RAMA --force > /dev/null 

echo "✅ ¡Actualización completada con éxito!"

read -p "ENTER para finalizar..." e


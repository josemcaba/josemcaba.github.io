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

# 3. NUEVO: Copiar plantillas OCR antes de hacer git
echo "📋 Paso 1: Copiando plantillas OCR..."
echo

# Rutas
SOURCE_FILE="$HOME/AppData/Roaming/FacturasApp/plantillas_ocr.xml"
DEST_FILE="./FacturasApp/Data/plantillas_ocr.xml"

# Verificar que el archivo fuente existe
if [ ! -f "$SOURCE_FILE" ]; then
    echo "✗ ERROR: No se encontró el archivo en:"
    echo "  $SOURCE_FILE"
    echo ""
    echo "Posibles causas:"
    echo "  - La aplicación no se ha ejecutado aún"
    echo "  - El archivo está en una ubicación diferente"
    echo ""
    read -p "ENTER para finalizar..." e
    exit 1
fi

# Crear directorio destino si no existe
mkdir -p "$(dirname "$DEST_FILE")"

# Copiar archivo
if cp "$SOURCE_FILE" "$DEST_FILE"; then
    echo "✓ Plantillas copiadas correctamente"
    echo
    echo "  De: $SOURCE_FILE"
    echo "  A:  $DEST_FILE"
    echo
else
    echo "✗ ERROR al copiar el archivo"
    read -p "ENTER para finalizar..." e
    exit 1
fi

# 4. VERIFICACIÓN: ¿Hay cambios reales?
echo "🔍 Paso 2: Verificando cambios..."
echo ""

cd "$REPO_ROOT"
# 'git status --porcelain' devuelve texto si hay cambios, o nada si está limpio.
if [[ -z $(git status --porcelain) ]]; then
    echo "✨ Todo está al día. No hay cambios para subir."
    echo
    read -p "ENTER para finalizar..." e
    exit 0
fi

# 5. Si llegamos aquí, es que hay cambios
echo "✓ Detectados cambios"
echo ""
echo "🛠️  Paso 3: Procesando cambios..."
echo ""

# 6. Ejecución silenciosa
git add .

# Intentar hacer amend para no llenar el log, o commit si es el primero
if git commit --amend -m "$MENSAJE" > /dev/null 2>&1; then
    echo "✓ Commit actualizado (amend)"
else
    git commit -m "$MENSAJE" > /dev/null 2>&1
    echo "✓ Nuevo commit creado"
fi

echo ""
echo "🚀 Paso 4: Subiendo a GitHub..."
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


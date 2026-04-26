#!/bin/bash

echo "============================================"
echo "  Actualiza Plantillas_OCR para publicación "
echo "============================================"
echo

# Rutas
SOURCE_FILE="$HOME/AppData/Roaming/FacturasApp/plantillas_ocr.xml"
DEST_DIR="$HOME/Carpeta DIGI storage/Mis Documentos (en DIGI)/PROYECTOS VISUAL STUDIO/FacturasApp/Data"

# 3. NUEVO: Copiar plantillas OCR antes de hacer git
echo "📋 Paso 1: Copiando plantillas OCR..."
echo

# Verificar que el archivo fuente existe
if [ ! -f "$SOURCE_FILE" ]; then
    echo "✗ ERROR: No se encontró el archivo:"
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
mkdir -p "$DEST_DIR"

# Copiar archivo
if cp "$SOURCE_FILE" "$DEST_DIR"; then
    echo "✓ Plantillas copiadas correctamente"
    echo
    echo "  De: $SOURCE_FILE"
    echo "  A:  $DEST_DIR"
    echo
else
    echo "✗ ERROR al copiar el archivo"
    read -p "ENTER para finalizar..." e
    exit 1
fi

echo
read -p "ENTER para finalizar..." e


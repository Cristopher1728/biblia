#!/bin/bash

RUTA_BASE="$(pwd)"
BIBLIA_COMPLETA="$RUTA_BASE/00_BIBLIA_RV_COMPLETO.txt"

abrir_con_vim() {
    ARCHIVO="$1"
    clear
    vim "$ARCHIVO"
    echo -e "\n✅ PRESIONA ENTER PARA VOLVER AL MENÚ..."
    read -r
}

while true; do
    OPCION=$(dialog --stdout --title "📖 BIBLIOTECA SAGRADA" \
        --backtitle "BIBLIA REINA VALERA + LIBROS EXTRACANÓNICOS + DEUTEROCANÓNICOS + NAG HAMMADI" \
        --menu "SELECCIONA UNA SECCIÓN:" 19 68 9 \
        "0" "📜 BIBLIA COMPLETA" \
        "1" "📖 ANTIGUO TESTAMENTO" \
        "2" "✝️ NUEVO TESTAMENTO" \
        "3" "📚 LIBROS EXTRACANÓNICOS — 13 LIBROS" \
        "4" "📙 LIBROS DEUTEROCANÓNICOS" \
        "5" "📜 NAG HAMMADI — 13 CÓDICES" \
        "S" "❌ SALIR")

    [ -z "$OPCION" ] && exit 0

    if [ "$OPCION" = "0" ]; then
        if [ -f "$BIBLIA_COMPLETA" ]; then
            abrir_con_vim "$BIBLIA_COMPLETA"
        else
            dialog --msgbox "⚠️ NO SE ENCONTRÓ:\n00_BIBLIA_RV_COMPLETO.txt" 8 55
        fi
        continue
    fi

    if [ "$OPCION" = "S" ]; then
        clear
        echo -e "\n🙏 QUE LA GRACIA DEL SEÑOR ESTÉ CON VOSOTROS. AMÉN.\n"
        exit 0
    fi

    case "$OPCION" in
        1) CARPETA="$RUTA_BASE/ANTIGUO_TESTAMENTO" ;;
        2) CARPETA="$RUTA_BASE/NUEVO_TESTAMENTO" ;;
        3) CARPETA="$RUTA_BASE/EXTRACANONICOS" ;;
        4) CARPETA="$RUTA_BASE/DEUTERO_CANONICOS" ;;
        5) CARPETA="$RUTA_BASE/NAG_HAMMADI" ;;
        *) continue ;;
    esac

    if [ ! -d "$CARPETA" ]; then
        dialog --msgbox "⚠️ CARPETA NO ENCONTRADA:\n$CARPETA" 8 55
        continue
    fi

    while true; do
        LISTA=()
        for ARCHIVO in $(ls -1 "$CARPETA"/*.txt | sort); do
            [ -f "$ARCHIVO" ] || continue
            SOLO_NOMBRE=$(basename "$ARCHIVO")
            LISTA+=("$SOLO_NOMBRE" "$SOLO_NOMBRE")
        done

        if [ ${#LISTA[@]} -eq 0 ]; then
            dialog --msgbox "📂 NO HAY LIBROS EN ESTA CARPETA" 8 50
            break
        fi

        SELECCIONADO=$(dialog --stdout --title "📖 LIBROS DISPONIBLES" \
            --menu "SELECCIONA PARA LEER | CANCELAR = VOLVER ATRÁS" 22 75 14 \
            "${LISTA[@]}")

        [ -z "$SELECCIONADO" ] && break

        RUTA_ARCHIVO="$CARPETA/$SELECCIONADO"
        abrir_con_vim "$RUTA_ARCHIVO"
    done
done


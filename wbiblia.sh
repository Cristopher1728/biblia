#!/data/data/com.termux/files/usr/bin/bash

ARCHIVO="biblia.txt"

while true; do
    clear
    # ========== VENTANA PRINCIPAL ==========
    OPCION=$(dialog --title "📖 BIBLIA — Lector" \
        --menu "Elige una opción:" 15 50 6 \
        1 "🔍 Buscar por nombre y capítulo" \
        2 "📖 Génesis — Capítulo 1" \
        3 "ℹ️  Ayuda" \
        0 "❌ Salir" \
        3>&1 1>&2 2>&3)

    [ $? -ne 0 ] && clear && exit 0

    case "$OPCION" in
        0) clear; exit 0 ;;
        3)
            dialog --title "ℹ️ Ayuda" --msgbox "\
Escribe así:
  GÉNESIS 1
  ÉXODO 3
  SALMO 23
  MTEO 5

Al salir de la lectura, vuelve aquí.
Presiona ESC o elige Salir para cerrar." 15 50
            continue
            ;;
        2) BUSCAR="GÉNESIS 1" ;;
        1|*)
            BUSCAR=$(dialog --title "🔍 Buscar" \
                --inputbox "Escribe: Libro + Capítulo\nEjemplos: GÉNESIS 1, MATEO 5" \
                12 55 \
                3>&1 1>&2 2>&3)
            [ $? -ne 0 ] && continue
            [ -z "$BUSCAR" ] && continue
            ;;
    esac

    # ========== ABRIR VIM Y MOSTRAR ==========
    vim -c "set ignorecase" -c "set number" -c "/$BUSCAR" -c "normal zt" "$ARCHIVO"
done

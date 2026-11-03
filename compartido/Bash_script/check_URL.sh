#!/bin/bash
clear

###############################
#
# Parametros:
#  - Lista Dominios y URL
#
#  Tareas:
#  - Se debera generar la estructura de directorio pedida con 1 solo comando con las tecnicas enseñadas en clases
#  - Generar los archivos de logs requeridos.
#
###############################

LISTA=$1

LOG_FILE="/var/log/status_url.log"

# 1. Generar la estructura de directorios requerida con 1 solo comando
sudo mkdir -p /var/log /tmp/head-check/{ok,Error/cliente,Error/servidor}

ANT_IFS=$IFS
IFS=$'\n'

for LINEA in `cat $LISTA | grep -v ^#`
do
    DOMINIO=$(echo $LINEA | awk '{print $1}')
    URL=$(echo $LINEA | awk '{print $2}')

    [ -z "$URL" ] && continue

    #---- Dentro del bucle ----#
    # Obtener el código de estado HTTP[cite: 33]
    STATUS_CODE=$(curl -LI -o /dev/null -w '%{http_code}\n' -s "$URL")

    # Fecha y hora actual en formato yyyymmdd_hhmmss[cite: 33]
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

    REGISTRO="$TIMESTAMP - Code:$STATUS_CODE - URL:$URL"

    # Registrar en el archivo /var/log/status_url.log[cite: 33]
    echo "$REGISTRO" | sudo tee -a "$LOG_FILE" > /dev/null

    # Definir la carpeta de destino sin usar if (usando evaluación en línea con &&)
    DIR="/tmp/head-check/ok"
    [[ "$STATUS_CODE" -ge 400 && "$STATUS_CODE" -le 499 ]] && DIR="/tmp/head-check/Error/cliente"
    [[ "$STATUS_CODE" -ge 500 && "$STATUS_CODE" -le 599 ]] && DIR="/tmp/head-check/Error/servidor"

    # Registrar en el archivo específico del dominio dentro de su carpeta correspondiente
    echo "$REGISTRO" | sudo tee -a "$DIR/$DOMINIO.log" > /dev/null
    #-------------------------#
done

IFS=$ANT_IFS

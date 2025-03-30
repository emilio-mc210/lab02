#!/bin/bash

DIRECTORIO="/home/emilio-marques/Pictures/Screenshots"
LOG="logs3.log"

echo "Monitoreando cambios en $DIRECTORIO"

inotifywait -m -r -e create -e modify -e delete -e move --format '%T %w%f %e' --timefmt '%Y-%m-%d %H-%M-%S' "$DIRECTORIO" >> $LOG
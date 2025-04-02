#!/bin/bash

#Verificar que solo sea 1 agumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 <comando>"
    exit 1
fi

COMANDO=$1  #Ejecuta el comando en segundo plano
$COMANDO &
PID=$!

LOGS="logs.log"
touch $LOGS #Crea el archivo si no existe

echo "Monitoreando el proceso $1 con PID: $PID"

#Revision periodica del proceso
while kill -0 $PID 2> /dev/null; do
    HORA=$(date +"%y-%m-%d %H-%M-%S")
    CPU=$(ps -p $PID -o %cpu=)
    MEM=$(ps -p $PID -o %mem=)
    echo "$HORA,$CPU,$MEM" >> "$LOGS"
    echo "Ejecutando..."
    sleep 0.5
done

echo "El proceso ha finalizado. Datos guardados en $LOGS"

#Generar grafico con gnuplot
gnuplot <<EOF
set datafile separator ','
set terminal png size 800,600
set output "grafico.png"
set title "Consumo de CPU y RAM"
set xlabel "Tiempo (s)"
set ylabel "Consumo (%)"
set xdata time
set timefmt "%y-%m-%d %H-%M-%S"
set format x "%M:%S"
plot "$LOGS" using 1:3 with lines title "RAM", "$LOGS" using 1:2 with lines title "CPU"
EOF

echo "Grafico generado como grafico.png"
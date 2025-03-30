#!/bin/bash

#Verificar si es root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: No es root >c"
    exit 1
fi

#Verificar que sean 3 argumentos
if [ $# -ne 3 ]; then
    echo "Uso: $0 <usuario> <grupo> <ruta_archivo>"
    exit 1
fi

USUARIO=$1
GRUPO=$2
RUTA=$3

#Verificar que la ruta del archivo existe
if [ ! -e $RUTA ]; then
    echo "Error ($(date)): La ruta del archivo no existe"
    exit 1
else
    echo "La ruta existe"
fi

#Verificar grupo
if [ $GRUPO = "$(cat /etc/group | grep -F "$GRUPO:" | awk -F ':' '{print $1}')" ]; then
    echo "El grupo solicitado ya existe"
else
    echo "Creando el grupo $GRUPO ..."
    groupadd "$GRUPO"
fi

#Verificar usuario
if [ $USUARIO = "$(cat /etc/passwd | grep -F "$USUARIO:" | awk -F ':' '{print $1}')" ]; then
    echo "El usuario $USUARIO ya existe"
else
    echo "El usuario $USUARIO no existe"
    echo "Creando usuario $USUARIO"
    adduser $USUARIO
fi

echo "Agregando $USUARIO a grupo $GRUPO"
usermod -a -G $GRUPO $USUARIO

#Pertenencia del archivo
chown "$USUARIO:$GROUP" "$RUTA"
echo "Ahora el archivo pertenece a $USUARIO:$GROUP"

#Permisos
chmod 740 "$RUTA"
echo "Permisos del archivo modificados"
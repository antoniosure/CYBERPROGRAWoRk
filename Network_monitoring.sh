#!/bin/bash 

# Función para verificar si 'ifstat' está instalado
function check_ifstat_installed {
    if ! command -v ifstat &> /dev/null; then
        echo "Error: ifstat no está instalado. Instálalo para volver a intentar."
        exit 1
    fi
}

# Función para monitorear la red un número determinado de veces
function network_monitoring {
    local n=$1
    for ((i = 1; i <= n; i++)); do
        ifstat 5 1
        sleep 5
    done
}

# Función para monitorear la red indefinidamente
function live_network_monitoring {
    echo "Presione Ctrl+C para salir"
    ifstat
}

# Función para manejar la opción de generar un reporte
function generate_report {
    local file=$1
    local n=$2
    if ! network_monitoring $n > "$file"; then
        echo "Error: No se pudo generar el archivo"
        exit 1
    else
        echo "El reporte ha sido generado en el archivo $file"
    fi
}

# Función para pedir la opción al usuario
function request_option {
    read -p "Elija una de las siguientes opciones:
    [1] Ver el monitoreo de red en vivo
    [2] Ver el monitoreo de red cierta cantidad de veces
    [3] Generar el monitoreo de red cierta cantidad de veces en un archivo
    " op
    while [ $op -ne 1 ] && [ $op -ne 2 ] && [ $op -ne 3 ]; do
        read -p "Ingrese una opción correcta (1, 2 o 3): " op
    done
    echo $op
}

# Función principal para manejar las opciones
function main {
    # Verificar si 'ifstat' está instalado
    check_ifstat_installed
    
    # Solicitar opción al usuario
    op=$(request_option)
    
    case $op in
        1)
            # Opción 1: Monitoreo en vivo
            live_network_monitoring
            ;;
        2)
            # Opción 2: Monitoreo un número definido de veces
            read -p "Ingrese la cantidad de veces que quiere ver el monitoreo: " num
            network_monitoring $num
            ;;
        3)
            # Opción 3: Generar reporte en un archivo
            read -p "Ingrese el nombre del reporte que quiere generar: " file
            read -p "Ingrese la cantidad de veces que quiere ver el monitoreo: " num
            generate_report $file $num
            ;;
        *)
            echo "Opción no válida"
            exit 1
            ;;
    esac
}

# Ejecutar la función principal
main

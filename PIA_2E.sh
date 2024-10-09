#!/bin/bash
# Cargar los módulos de los otros scripts

source ./Get_ports.sh
source ./Network_monitoring.sh

read -rp "Menu
1) Escaneo de puertos
2) Monitoreo de red
3) Salir del programa
Ingrese un numero [1-3]: " opc
echo ""
echo ""

until [ $opc = 3 ]
do
  if [ $opc = 1 ]; then
    Get_Ports
  fi
  
  if [ $opc = 2 ]; then
    check_ifstat_installed
    echo "Seleccione una opción:"
    echo "1) Monitoreo en vivo de la red"
    echo "2) Monitorear la red por un número definido de veces"
    echo "3) Generar reporte de monitoreo"
    read -rp "Elija una opción: " sub_opcion
    
    case $sub_opcion in
        1)
            live_network_monitoring
            ;;
        2)
            read -rp "Ingrese la cantidad de veces que quiere monitorear la red: " num
            network_monitoring $num
            ;;
        3)
            read -rp "Ingrese el nombre del archivo de reporte: " file
            read -rp "Ingrese la cantidad de veces que quiere monitorear: " num
            generate_report $file $num
            ;;
        *)
            echo "Opción no válida"
            ;;
    esac
  fi

  echo ""
  echo "Redirigiendo al menu..."
  echo ""
  read -rp "Menu
1) Escaneo de puertos
2) Monitoreo de red
3) Salir del programa
Ingrese un numero [1-3]: " opc
  echo ""
  echo ""

done

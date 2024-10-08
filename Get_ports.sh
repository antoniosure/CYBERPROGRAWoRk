#Esta primera función de (Obtener_Adaptadores) lo que nos hace es sacar los adaptadores de red que nosotros tenemos en
#nuestra red.
function Obtener_Adaptadores() {
    echo "Entraste a la opción para saber cuáles son tus adaptadores en la red"
    if ! command -v ifconfig &> /dev/null; then
        echo "ifconfig no está instalado. Instalando net-tools..."
        sudo apt update
        sudo apt install -y net-tools
        #Con este if verificamos si ifconfig esta descargado en la terminal de linux que este nos ayuda a saber los puertos que vamos a verificar asi como la ip, mascara de subnet 
            # y otras especificaciones, aqui lo usaremos para saber cuales son los adpatadroes de la red que esta usasndo el dispositivo.
    fi
    ifconfig -a > adaps.txt
    cat adaps.txt
}

# Función para pentesting en redes privadas
function Get_Ports() {
    read -pr "Ingrese la opción [1] para proporcionar la IP de algún dispositivo, [2] para usar la IP del adaptador testeado o [3] para salir: " opc1
    case $opc1 in 
            1)
                echo "Elegiste la opción número 1"
            
                read -pr "Ingrese la IP de la que vamos a mostrar la información: " ipsele
                if ! command -v nmap &> /dev/null; then
                    echo "nmap no está instalado. Instalando nmap..."
                    sudo apt-get install -y nmap
                    #Aqui volvemos a verificar si Nmap esta en el dispositivo si no la descargamos.
                fi
                #Como aqui habiamos pedido una ip especifica se van a mapear los puertos de la ip seleccionada.
                PortsMapping=$(nmap $ipsele > Mapeo.txt)
                while IFS= read -r echo1; do
                    echo "$echo1"
                done < Mapeo.txt

                echo "A continuación le mostraremos cuales son los puertos con las vulnerabilidades mas comunes"

                cat puertos.txt 
                
                ;;
            2)
                echo "Elegiste la opción número 2"
            
                read -pr "Ingrese el adaptador que quieres que sea testeado: " adaptador
                ip=$(ifconfig $adaptador | grep 'inet ' | awk '{print $2}')
                echo "La dirección IP es $ip"
                #Aqui usamos grep para buscar las coincidencias que se imprimieron y se mandaron a guardar con el adaptador que escogemos y guardamos
                #la ip en una variable.

                if ! command -v nmap &> /dev/null; then
                    echo "nmap no está instalado. Instalando nmap..."
                    sudo apt-get install -y nmap
                fi
        
                PortsMapping=$(nmap $ip > Mapeo.txt)
                while IFS= read -r echo1; do
                    echo "$echo1"
                done < Mapeo.txt

                cat Mapeo.txt
               

                ;;
            3)
                echo "Saliendo..."
                exit 0
                ;;
        esac
    }

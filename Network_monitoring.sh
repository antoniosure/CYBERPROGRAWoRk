# Función para verificar si 'ifstat' está instalado
function check_ifstat_installed() {
    if ! command -v ifstat &> /dev/null; then
        echo "Error: ifstat no está instalado. Instálalo para continuar."
        exit 1
    fi
}

# Función para monitorear la red un número determinado de veces
function network_monitoring() {
    local n=$1
    for ((i = 1; i <= n; i++)); do
        ifstat 5 1
        sleep 5
    done
}

# Función para monitoreo en vivo
function live_network_monitoring() {
    echo "Presione Ctrl+C para salir"
    ifstat
}

# Función para generar un reporte
function generate_report() {
    local file=$1
    local n=$2
    if ! network_monitoring $n > "$file"; then
        echo "Error: No se pudo generar el archivo"
        exit 1
    else
        echo "El reporte ha sido generado en el archivo $file"
    fi
}

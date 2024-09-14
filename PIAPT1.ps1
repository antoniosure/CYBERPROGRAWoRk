$repetir = Get-Service
foreach($reg in $repetir){
$menu = "Menu
1)Revision de hashes y consulta de API
2)Visualizar archivos ocultos 
3)Revision de uso de recursos del sistema
4)Obtener permisos inseguros
5)Salir
Ingresa un numero [1-5]: "
$opc = Read-Host -Prompt $menu
switch ($opc) {
      1{
        #Reporte virus total
        function Get-VirusTotalReport {
        #De parametros te pide la ubicacion del archivo local que se quiere analizar
            Param (
                [Parameter(Mandatory=$true)]
                [String]$FilePath
            )
            #Hacemos un try catch para verificar el path del archivo a verificar en caso de que no se encuentre
            #El archivo con el comando Test-Path lanzará el mensaje de que el archivo no existe en la ruta indicada,
            #Es mas que preventivo el Test-File para que el comando no se ejecute si no se encuientra la ruta.
            try {
                if (-Not (Test-Path -Path $FilePath)) {
                    throw "El archivo no existe en la ruta especificada."
                }
            #Obtenemos el ash del archivo
            $fileHash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash
            #Consultamos  el API de Virus Total
            $headers = @{
                'x-apikey' = "74aa481607cbd2321823ed749b244f5ca3a2b39011d74e34aad20b72898476cb"
            }
            $response = Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/files/$fileHash" -Method Get -Headers $headers
            $response.data.attributes.last_analysis_stats
            } catch {
                Write-Error "Error al obtener el reporte hash de VirusTotal: $_"
            }
        }
    } 2{ 
    
        #Función para listar los archivos ocultos dentro de una carpeta determinada
        #Autor:Montserrat Elizeth Ramírez Cuéllar
        function Get-HiddenFiles {
            param (
                [parameter(Mandatory)][string]$ruta
            )
            #Verifica si la ruta existe
            if (-not (Test-Path -Path $ruta)) {
                Write-Host "La carpeta especificada no existe."
                return
            }
            #Realiza la búsqueda de archivos ocultos dentro de la carpeta
            $archivosOcultos = Get-ChildItem -Path $ruta -Force | Where-Object { $_.Attributes -match "Hidden" }

            #Si no existen archivos ocultos, imprime que no se encontraron, de lo contrario imprime el listado        
            if ($archivosOcultos.Count -eq 0) {
                Write-Host "No se encontraron archivos ocultos."
            } else {
                Write-Host "Listado de archivos ocultos:"
                $archivosOcultos | ForEach-Object { Write-Host $_.FullName }
            }
        }
     #Dentro del menú se le pide al usuario que ingrese la ruta de la carpeta, se guarda en una variable
     $carpeta = Read-Host "Ingrese la ruta de la carpeta de la cual desea obtener los archivos ocultos"
     #Manda a llamar a la función con la variable que contiene la ruta ingresada por el usuario
     Get-HiddenFiles -ruta "$carpeta"  
      
    } 3{
        
        function Get-SystemResourceUsage {
            # Uso de CPU
            $cpuUsage = Get-WmiObject -Query "SELECT * FROM Win32_Processor" | Select-Object -ExpandProperty LoadPercentage

            # Uso de memoria
            $memory = Get-CimInstance -ClassName Win32_OperatingSystem
            $totalMemory = $memory.TotalVisibleMemorySize / 1MB
            $freeMemory = $memory.FreePhysicalMemory / 1MB
            $usedMemory = $totalMemory - $freeMemory

            # Uso de red
            $network = Get-WmiObject -Class Win32_PerfFormattedData_Tcpip_NetworkInterface
            $networkBytesPerSec = $network.BytesTotalPersec

            # Mostrar resultados
            [PSCustomObject]@{
                CPU_Usage_Percent = $cpuUsage
                Memory_Used_MB = $usedMemory
                Memory_Available_MB = $freeMemory
                Network_Bytes_Per_Second = $networkBytesPerSec
            }
        }
        $result = Get-SystemResourceUsage
        $result
        
    } 4{
            
        $carpeta = Read-Host "Ingersar path para revision de permisos inseguros"

        Get-InsecureFilePermissions -path  $carpeta # Habilitar modo estricto
Set-StrictMode -Version Latest

# Función para checar los permisos inseguros
function Get-InsecureFilePermissions {
<#
DESCRIPTION
Analiza los permisos de los archivos y carpetas en una ruta específica y detecta si se supone que hay configuraciones inseguras.

.PARAMETER Path
Ruta

.NOTITAS
Autor: Javier Abraham Palomares Garcia
Versión: 1.0
#>

param (
    [Parameter(Mandatory = $true, HelpMessage = "Escribe la ruta del archivo o carpeta")]
    [string]$Path
)

# Uso de errores y validaciones
try {
    if (-not (Test-Path -Path $Path)) {
        Write-Host "La ruta hacia el archivo/carpeta al parecer no existe: $Path"
    }
   
    # Buscamos la lista de archivos segun el get-child
    $items = Get-ChildItem -Path $Path -Recurse -Force
    foreach ($item in $items) {
        try {
            # Obtener los permisos de cada archivo/carpeta
            $acl = Get-Acl -Path $item.FullName
            $permissions = $acl.Access
           
            # Revisar si hay permisos inseguros (ej: asignaciones a 'Everyone' o 'Usuarios')
            foreach ($permission in $permissions) {
                if ($permission.IdentityReference -match "Everyone" -or $permission.IdentityReference -match "Usuarios") {
                    Write-Host "Permiso inseguro en $($item.FullName) para $($permission.IdentityReference)"
                }
            }
        }
        catch {
            Write-Error "Error revisando permisos en: $($item.FullName). Error: $_"
        }
    }
}
catch {
    Write-Error "Error en la ruta especificada: $_"
}
}
} 5{
        Write-Host "Adios"
        break foreach
    } default {
    Write-Host "Es necesario elegir una opcion"
    }
}
}
 # Definición de funciones
function Get-VirusTotalReport {
    param (
        [Parameter(Mandatory=$true)]
        [String]$FilePath
    )
    try {
        if (-Not (Test-Path -Path $FilePath)) {
            throw "El archivo no existe en la ruta especificada."
        }
        $fileHash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash
        $headers = @{
            'x-apikey' = "74aa481607cbd2321823ed749b244f5ca3a2b39011d74e34aad20b72898476cb"
        }
        $response = Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/files/$fileHash" -Method Get -Headers $headers
        $response.data.attributes.last_analysis_stats
    } catch {
        Write-Error "Error al obtener el reporte hash de VirusTotal: $_"
    }
}

function Get-HiddenFiles {
    param (
        [parameter(Mandatory)][string]$ruta
    )
    if (-not (Test-Path -Path $ruta)) {
        Write-Host "La carpeta especificada no existe."
        return
    }
    $archivosOcultos = Get-ChildItem -Path $ruta -Force | Where-Object { $_.Attributes -match "Hidden" }
    if ($archivosOcultos.Count -eq 0) {
        Write-Host "No se encontraron archivos ocultos."
    } else {
        Write-Host "Listado de archivos ocultos:"
        $archivosOcultos | ForEach-Object { Write-Host $_.FullName }
    }
}

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

function Get-InsecureFilePermissions {
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


# Menú de opciones
while ($true) {
    $menu = @"
Menu
1) Revisión de hashes y consulta de API
2) Visualizar archivos ocultos 
3) Revisión de uso de recursos del sistema
4) Obtener permisos inseguros
5) Salir
Ingresa un numero [1-5]: 
"@
    $opc = Read-Host -Prompt $menu

    switch ($opc) {
        1 {
            $filePath = Read-Host "Ingrese la ruta del archivo para analizar con VirusTotal"
            if ($filePath) {
                Get-VirusTotalReport -FilePath $filePath
            } else {
                Write-Host "Ruta de archivo no proporcionada."
            }
        }
        2 {
            $carpeta = Read-Host "Ingrese la ruta de la carpeta de la cual desea obtener los archivos ocultos"
            if ($carpeta) {
                Get-HiddenFiles -ruta $carpeta
            } else {
                Write-Host "Ruta de carpeta no proporcionada."
            }
        }
        3 {
            $result = Get-SystemResourceUsage
            $result | Format-List
        }
        4 {
            $carpeta = Read-Host "Ingrese la ruta para la revisión de permisos inseguros"
            if ($carpeta) {
                Get-InsecureFilePermissions -Path $carpeta
            } else {
                Write-Host "Ruta de carpeta no proporcionada."
            }
        }
        5 {
            Write-Host "Adiós"
            break
        }
        default {
            Write-Host "Es necesario elegir una opción válida"
        }
    }
}

# Función para mostrar la memoria RAM disponible
function Get-AvailableRAM {
    Write-Host "Uso de Memoria RAM:"
    Get-WmiObject Win32_OperatingSystem | Select-Object @{Name="Memoria total visible (GB)";Expression={[math]::round($_.TotalVisibleMemorySize / 1MB, 2)}}, @{Name="Memoria física disponible (GB)";Expression={[math]::round($_.FreePhysicalMemory / 1MB, 2)}}
}

# Función para mostrar los procesos que más usan CPU
function Get-TopCPUProcesses {
    Write-Host "Procesos que más consumen CPU:"
    [int]$TopN = Read-Host "Ingrese cuantos procesos desea ver"
    Get-Process | Sort-Object CPU -Descending | Select-Object -First $TopN Id, ProcessName, CPU
}

# Función para mostrar los adaptadores de red
function Get-NetworkAdapters {
    Write-Host "Adaptadores de Red:"
    Get-NetAdapter | Select-Object Name, Status, LinkSpeed
}

# Función para mostrar estadísticas de red
function Get-NetworkStatistics {
    Write-Host "Estadísticas de Red:"
    Get-NetAdapterStatistics | Select-Object Name, ReceivedBytes, SentBytes
}

# Función para mostrar información de los discos físicos
function Get-PhysicalDisks {
    Write-Host "Discos Físicos:" 
    Get-PhysicalDisk | Select-Object FriendlyName, MediaType, HealthStatus, @{
        Name="Size (GB)";
        Expression={[math]::round($_.Size / 1GB, 2)}
    }
}

# Función para mostrar información de los discos lógicos
function Get-LogicalDisks {
    Write-Host "Discos Lógicos:"
    Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, VolumeName, @{
        Name="Size (GB)";
        Expression={[math]::round($_.Size / 1GB, 2)}
    }, @{
        Name="FreeSpace (GB)";
        Expression={[math]::round($_.FreeSpace / 1GB, 2)}
    }
}

# Función principal para mostrar el menú de opciones
function Show-Menu {
    Clear-Host
    Write-Host "----- Revisión de Uso de Recursos del Sistema -----" 
    Write-Host "1. Mostrar uso de Memoria RAM"
    Write-Host "2. Mostrar procesos con mayor uso de CPU"
    Write-Host "3. Mostrar adaptadores de red"
    Write-Host "4. Mostrar estadísticas de red"
    Write-Host "5. Mostrar estado de los discos físicos"
    Write-Host "6. Mostrar memoria de los discos lógicos"
    Write-Host "7. Salir"
    Write-Host "---------------------------------------------------"
    
    $choice = Read-Host "Seleccione una opción [1-7]"

    switch ($choice) {
        1 { Get-AvailableRAM }
        2 { Get-TopCPUProcesses }
        3 { Get-NetworkAdapters }
        4 { Get-NetworkStatistics }
        5 { Get-PhysicalDisks }
        6 { Get-LogicalDisks }
        7 { Write-Host "Saliendo del programa..."; exit }
        default { Write-Host "Opción no válida. Intente de nuevo."}
    }

    # Espera antes de mostrar el menú de nuevo
    Write-Host "`nPresione cualquier tecla para continuar..."
    [void][System.Console]::ReadKey($true)
    Show-Menu
}

# Ejecuta el menú principal
Show-Menu
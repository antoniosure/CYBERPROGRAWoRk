function Get-Resources {
    <#
    .SYNOPSIS
    Muestra información del sistema basada en la opción seleccionada.

    .DESCRIPTION
    Esta función permite obtener información específica del sistema como el uso de RAM, los procesos que más consumen CPU, adaptadores de red, estadísticas de red, discos físicos y discos lógicos. El usuario debe especificar una opción usando el parámetro `-Opcion`.

    .PARAMETER Opcion
    Este parámetro obligatorio define qué tipo de información mostrar. Los valores posibles son:
    - RAM: Muestra el uso de memoria RAM disponible.
    - CPU: Muestra los procesos que más CPU consumen.
    - NetworkAdapters: Muestra información sobre los adaptadores de red.
    - NetworkStatistics: Muestra estadísticas de red.
    - PhysicalDisks: Muestra información de los discos físicos.
    - LogicalDisks: Muestra información de los discos lógicos.

    .EXAMPLE
    Get-Resources -Opcion RAM
    Muestra la información de la memoria RAM disponible.

    .EXAMPLE
    Get-Resources -Opcion CPU
    Muestra los procesos que más consumen CPU y pide al usuario cuántos procesos mostrar.

    .EXAMPLE
    Get-Resources -Opcion NetworkAdapters
    Muestra la lista de adaptadores de red.

    .NOTES
    Autor: David del Toro
    Fecha: 18/09/2024
    Versión: 1.1
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("RAM", "CPU", "NetworkAdapters", "NetworkStatistics", "PhysicalDisks", "LogicalDisks")]
        [string]$Opcion
    )

    switch ($Opcion) {
        "RAM" {
            # Mostrar memoria RAM disponible
            Write-Host "Uso de Memoria RAM:"
            Get-WmiObject Win32_OperatingSystem | Select-Object @{Name="Memoria total visible (GB)";Expression={[math]::round($_.TotalVisibleMemorySize / 1MB, 2)}}, @{Name="Memoria física disponible (GB)";Expression={[math]::round($_.FreePhysicalMemory / 1MB, 2)}}
        }
        
        "CPU" {
            # Mostrar procesos que más usan CPU
            Write-Host "`nProcesos que más consumen CPU:"
            [int]$TopN = Read-Host "Ingrese cuantos procesos desea ver (Muestra los procesos que consumen mas CPU de mayor a menor): "
            Get-Process | Sort-Object CPU -Descending | Select-Object -First $TopN Id, ProcessName, CPU
        }
        
        "NetworkAdapters" {
            # Mostrar adaptadores de red
            Write-Host "`nAdaptadores de Red:"
            Get-NetAdapter | Select-Object Name, Status, LinkSpeed
        }
        
        "NetworkStatistics" {
            # Mostrar estadísticas de red
            Write-Host "`nEstadísticas de Red:"
            Get-NetAdapterStatistics | Select-Object Name, ReceivedBytes, SentBytes
        }
        
        "PhysicalDisks" {
            # Mostrar información de los discos físicos
            Write-Host "`nDiscos Físicos:"
            Get-PhysicalDisk | Select-Object FriendlyName, MediaType, HealthStatus, @{
                Name="Size (GB)";
                Expression={[math]::round($_.Size / 1GB, 2)}
            }
        }
        
        "LogicalDisks" {
            # Mostrar información de los discos lógicos
            Write-Host "`nDiscos Lógicos:"
            Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, VolumeName, @{
                Name="Size (GB)";
                Expression={[math]::round($_.Size / 1GB, 2)}
            }, @{
                Name="FreeSpace (GB)";
                Expression={[math]::round($_.FreeSpace / 1GB, 2)}
            }
        }
    }
}

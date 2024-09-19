<#
.SYNOPSIS
Este comando nos ayuda a saber los recursos del sistema donde se ejecutó el código.

.DESCRIPTION
Solo se ejecuta el módulo y nos dará la información que indica proporcionar el comando, como la memoria usada, CPU, memoria disponible y los bytes por segundo que pasan por el dispositivo.

.PARAMETER NombreDelParametro
No existen parámetros para introducir en este módulo.

.EXAMPLE
Solo ejecuta el comando en tu terminal de PowerShell y nos dará la información indicada.

.NOTES
La información cambia constantemente con el dispositivo.
#>
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

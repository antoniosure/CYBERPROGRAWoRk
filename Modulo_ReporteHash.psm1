<#
.SYNOPSIS
Este comando nos ayuda a saber si un archvivo ha sido corrompido al nivel de saber si el archivo es malicioso, sospechoso o si algo ha sido detectado etc.

.DESCRIPTION
Solo se ejecuta el módulo colocamos el -Path con todo y archivo del mismo que queremos auditar  y nos arrojará la iunformación ya dicha.

.PARAMETER NombreDelParametro
El unico parametro a introducir es el path del archivo completo.

.EXAMPLE
Solo ejecuta el comando en tu terminal de PowerShell y el path.
Get-VirusTotalReport 
Ingrese la ruta del archivo para analizar con VirusTotal: C:\Users\Aula403-28\Documents\servicios.txt

.NOTES
No hay notas.
#>

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
        $response.data.attributes
    } catch {
        Write-Error "Error al obtener el reporte hash de VirusTotal: $_"
    }
}
Get-VirusTotalReport

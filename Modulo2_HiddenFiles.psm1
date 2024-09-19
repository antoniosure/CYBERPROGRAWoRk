function HiddenFiles {
    <#
    .SYNOPSIS
    Muestra una lista de archivos ocultos en una carpeta específica.

    .DESCRIPTION
    Esta función permite al usuario especificar una ruta y listará todos los archivos ocultos
    encontrados en esa ruta. Si la carpeta no existe o no hay archivos ocultos, se informará
    al usuario.

    .PARAMETER ruta
    Ruta de la carpeta donde se buscarán archivos ocultos. Este parámetro es obligatorio.

    .EXAMPLE
    HiddenFiles -ruta "C:\MiCarpeta"
    Este ejemplo buscará y mostrará todos los archivos ocultos en "C:\MiCarpeta".

    .NOTES
    Autor: Montserrat Elizeth Ramírez Cuéllar
    Versión: 01
    #>

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

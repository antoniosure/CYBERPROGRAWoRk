function HiddenFiles {
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
            

# Habilitar modo estricto
Set-StrictMode -Version Latest

# Función para checar los permisos inseguros
function Get-InsecureFilePermissions {
    <#
    .SYNOPSIS
    Revisa los permisos de archivos y carpetas en la ubicación especificada.

    .DESCRIPTION
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

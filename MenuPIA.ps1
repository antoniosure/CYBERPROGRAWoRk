$repetir = Get-Service
foreach($reg in $repetir){
$menu = "Menu
1)Revision de hashes y consulta de API
2)Visualizar archivos ocultos 
3)Revision de uso de recursos del sistema
4)¿¿Tarea adicional??
5)Salir
Ingresa un numero [1-5]: "
$opc = Read-Host -Prompt $menu
switch ($opc) {
      1{
        $variable1 = Read-Host -Prompt "Ingresa que archivo hash deseas visualizar bajo los archivos locales"
    } 2{
        $variable2 = Read-Host -Prompt "Ingresa el listado de archivos ocultos que desea ver"
    } 3{
        Read-Host "Ingresa que recurso deseas ver"
    } 4{
        Read-Host "¿¿Tarea adicional??"
    } 5{
        Write-Host "Adios"
        break foreach
    } default {
    Write-Host "Es necesario elegir una opcion"
    }
}
}
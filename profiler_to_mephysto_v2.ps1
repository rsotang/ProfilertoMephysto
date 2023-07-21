# Función para seleccionar datos X
Function Seleccionar-DatosX {
    Param ($nombreArchivo)
    $lineas = Get-Content $nombreArchivo
    $lineaInicio = $lineas.IndexOf("Detector ID`tX Axis Position(cm)`tSet 1") + 1
    $lineaFinal = $lineas.IndexOf("Detector ID`tY Axis Position(cm)`tSet 1")-1
    $lineas[$lineaInicio..$lineaFinal] -replace ',', '.'
}

# Función para seleccionar datos Y
Function Seleccionar-DatosY {
    Param ($nombreArchivo)
    $lineas = Get-Content $nombreArchivo
    $lineaInicio = $lineas.IndexOf("Detector ID`tY Axis Position(cm)`tSet 1")+1
    $lineaFinal = $lineaInicio + 90
    $lineas[$lineaInicio..$lineaFinal] -replace ',', '.'
}

# Función para insertar datos
Function Insertar-Datos {
    Param ($datos1, $datos2, $nombreArchivo)

 # Crear una copia del archivo original
    $nombreArchivoCopia = "copia_" + $nombreArchivo
    Copy-Item -Path $nombreArchivo -Destination $nombreArchivoCopia

    $lineas = Get-Content $nombreArchivoCopia
    $lineaInicio1 = $lineas.IndexOf("`tBEGIN_SCAN  1") + 73
    $lineaFinal1 = $lineas.IndexOf("`tEND_SCAN  1") - 2
    $lineaInicio2 = $lineas.IndexOf("`tBEGIN_SCAN  2") + 73
    $lineaFinal2 = $lineas.IndexOf("`tEND_SCAN  2") - 2
    $nuevasLineas = $lineas[0..($lineaInicio1-1)] + $datos1 + $lineas[$lineaFinal1..($lineaInicio2-1)] + $datos2 + $lineas[$lineaFinal2..$lineas.Length]
    Set-Content -Path $nombreArchivoCopia -Value $nuevasLineas

# Renombrar el archivo copia
    Rename-Item -Path $nombreArchivoCopia -NewName "mephysto_data.mcc"
}



# Código principal
$nombreArchivo = "mephysto_data.mcc"  # Cambia esto por el nombre del archivo que quieres buscar
if (Test-Path $nombreArchivo) {   
    Remove-Item -Path $nombreArchivo
} 
$datosX = Seleccionar-DatosX -nombreArchivo 'Profiler2Export.txt'
$datosY = Seleccionar-DatosY -nombreArchivo 'Profiler2Export.txt'
Insertar-Datos -datos1 $datosX -datos2 $datosY -nombreArchivo 'plantilla_mephysto.txt'
Write-Output "Cambiando archivos"
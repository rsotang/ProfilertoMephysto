# Función para seleccionar datos
Function Seleccionar-Datos {
    Param ($nombreArchivo)
    $lineas = Get-Content $nombreArchivo
    $lineaInicio = $lineas.IndexOf("Detector ID`tX Axis Position(cm)`tSet 1") + 1
    $lineaFinal = $lineas.IndexOf("Detector ID`tY Axis Position(cm)`tSet 1")-1
    $lineas[$lineaInicio..$lineaFinal] -replace ',', '.'
}

# Función para insertar datos
Function Insertar-Datos {
    Param ($datos, $nombreArchivo)
    # Crear una copia del archivo original
    $nombreArchivoCopia = "copia_" + $nombreArchivo
    Copy-Item -Path $nombreArchivo -Destination $nombreArchivoCopia

    $lineas = Get-Content $nombreArchivoCopia
    $lineaInicio = $lineas.IndexOf("`t`tBEGIN_DATA") + 1
    $lineaFinal = $lineas.IndexOf("`t`tEND_DATA")
    $nuevasLineas = $lineas[0..($lineaInicio-1)] + $datos + $lineas[$lineaFinal..$lineas.Length]
    Set-Content -Path $nombreArchivoCopia -Value $nuevasLineas

    # Renombrar el archivo copia
    Rename-Item -Path $nombreArchivoCopia -NewName "mephysto_data.mcc"
}



# Código principal
$datos = Seleccionar-Datos -nombreArchivo 'Profiler2Export.txt'
Insertar-Datos -datos $datos -nombreArchivo 'plantilla_mephysto.txt'
Write-Output "Cambiando archivos"
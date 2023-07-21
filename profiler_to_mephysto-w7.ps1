# Función para obtener el índice de la línea
Function Get-LineIndex {
    Param ($lines, $match)
    for ($i=0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -eq $match) {
            return $i
        }
    }
    return -1
}
Function Get-LineIndex1 {
    Param ($lines, $match)
    for ($i=0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -eq $match) {
            return $i +1 
        }
    }
    return -1
}

Function Get-LineIndex2 {
    Param ($lines, $match)
    for ($i=0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -eq $match) {
            return $i -1
        }
    }
    return -1
}

# Función para seleccionar datos
Function Seleccionar-Datos {
    Param ($nombreArchivo)
    $lineas = Get-Content $nombreArchivo
    $lineaInicio = Get-LineIndex1 $lineas "Detector ID`tX Axis Position(cm)`tSet 1"
    $lineaFinal = Get-LineIndex2 $lineas "Detector ID`tY Axis Position(cm)`tSet 1" 
    for ($i=$lineaInicio; $i -le $lineaFinal; $i++) {
        $lineas[$i] -replace ',', '.'
    }
}

# Función para insertar datos
Function Insertar-Datos {
    Param ($datos, $nombreArchivo)
    # Crear una copia del archivo original
    $nombreArchivoCopia = "copia_" + $nombreArchivo
    Copy-Item -Path $nombreArchivo -Destination $nombreArchivoCopia

    $lineas = Get-Content $nombreArchivoCopia
    $lineaInicio = Get-LineIndex1 $lineas "`t`tBEGIN_DATA"
    $lineaFinal = Get-LineIndex $lineas "`t`tEND_DATA"
    $nuevasLineas = @()
    for ($i=0; $i -lt $lineaInicio; $i++) { $nuevasLineas += $lineas[$i] }
    $nuevasLineas += $datos
    for ($i=$lineaFinal; $i -lt $lineas.Length; $i++) { $nuevasLineas += $lineas[$i] }
    Set-Content -Path $nombreArchivoCopia -Value $nuevasLineas

    # Renombrar el archivo copia
    Rename-Item -Path $nombreArchivoCopia -NewName "mephysto_data.mcc"
}


# Código principal
$datos = Seleccionar-Datos -nombreArchivo 'Profiler2Export.txt'
Insertar-Datos -datos $datos -nombreArchivo 'plantilla_mephysto.txt'
Write-Output "Cambiando archivos"
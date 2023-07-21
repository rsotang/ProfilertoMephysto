# Función para obtener el índice de la línea
Function Get-LineIndex {
    Param ($lines, $match)
    for ($i=0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -eq $match) {
			#Write-Host 	$lines[$i] $i #hay que usar host en vez de output por cosas de powershell
            return $i 	
			
        }
    }
	 
    return -1
}

Function Get-LineIndex1 {
    Param ($lines, $match)
    for ($i=0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -eq $match) {
			#Write-Host 	$lines[$i] $i
            return $i	
		
        }
    }
    return -1
}

Function Get-LineIndex2 {
    Param ($lines, $match)
    for ($i=0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -eq $match) {
			#Write-Host 	$lines[$i] $i
            return $i		
			
        }
    }
    return -1
}

Function Get-LineIndex3 {
    Param ($lines, $match)
    for ($i=0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -eq $match) {
			#Write-Host 	$lines[$i] $i
            return $i
			
			
			
        }
    }
    return -1
}

#Función para seleccionar datos X
Function Seleccionar-DatosX {
    Param ($nombreArchivo)
    $lineas = Get-Content $nombreArchivo
    $lineaInicio = Get-LineIndex $lineas "Detector ID`tX Axis Position(cm)`tSet 1"  #+ 1
	$lineaInicio =  $lineaInicio +1
    $lineaFinal = Get-LineIndex1 $lineas "Detector ID`tY Axis Position(cm)`tSet 1" #-1
	$lineaFinal= $lineaFinal -1
    for ($i=$lineaInicio; $i -le $lineaFinal; $i++) {
        $lineas[$i] -replace ',', '.'
    }
	#Write-Host "datosX"
}

# Función para seleccionar datos Y
Function Seleccionar-DatosY {
    Param ($nombreArchivo)
    $lineas = Get-Content $nombreArchivo
    $lineaInicio = Get-LineIndex2 $lineas "Detector ID`tY Axis Position(cm)`tSet 1" #+2
	$lineaInicio =  $lineaInicio +2
    $lineaFinal = $lineaInicio + 88
     for ($i=$lineaInicio; $i -le $lineaFinal; $i++) {
        $lineas[$i] -replace ',', '.'
    }
	#Write-Host "datosY"
}
# Función para insertar datos
Function Insertar-Datos {
    Param ($datos1, $datos2, $nombreArchivo)

    # Crear una copia del archivo original
    $nombreArchivoCopia = "copia_" + $nombreArchivo
    Copy-Item -Path $nombreArchivo -Destination $nombreArchivoCopia

    $lineas = Get-Content $nombreArchivoCopia
	#Write-Host $lineas
    $lineaInicio1 = Get-LineIndex $lineas "`tBEGIN_SCAN  1" #+ 73 #creo que no le gusta sumar cosas 
	Write-Host $lineaInicio1
	$lineaInicio1 = $lineaInicio1+73
	Write-Host $lineaInicio1
    $lineaFinal1 = Get-LineIndex1 $lineas "`tEND_SCAN  1" #- 2
	Write-Host $lineaFinal1
	$lineaFinal1 = $lineaFinal1 -2
	Write-Host $lineaFinal1
    $lineaInicio2 = Get-LineIndex2 $lineas "`tBEGIN_SCAN  2" #+ 73
	Write-Host $lineaInicio2
	$lineaInicio2 = $lineaInicio2+73
	Write-Host $lineaInicio2
    $lineaFinal2 = Get-LineIndex3 $lineas "`tEND_SCAN  2" #- 2
	Write-Host $lineaFinal2
	$lineaFinal2 = $lineaFinal2 -2
	Write-Host $lineaFinal2
    $nuevasLineas = @()
	#$nuevasLineas = ,''*1000
	
    for ($i=0; $i -lt $lineaInicio1; $i++) { 
		$nuevasLineas += $lineas[$i]
		#Write-Host $nuevasLineas[$i]
		}	
    $nuevasLineas += $datos1
	#Write-Host $nuevasLineas
	#Write-Host "---------------------------PRIMER CAMBIO -------------------------------"
    for ($i=$lineaFinal1; $i -lt $lineaInicio2; $i++) {
		$nuevasLineas += $lineas[$i]
		#Write-Host $nuevasLineas[$i] 
		#if ($i -eq 77) {Write-Host "longi"}
	}
	
    $nuevasLineas += $datos2
	#Write-Host $nuevasLineas
	#Write-Host "--------------------------SEGUNDO CAMBIO --------------------------------"
    for ($i=$lineaFinal2; $i -lt $lineas.Length; $i++) { 
	$nuevasLineas += $lineas[$i]
	#Write-Host $nuevasLineas[$i]
	}
	#Write-Host $nuevasLineas
	#Write-Host "--------------------------------FIN--------------------------------------"
	
	<# $j =0
	$k=0
	#Write-Host $lineas
	for ($i=0; $i -lt 500; $i++) { #pongo mil lineas porque creo que el primer fallo es que itero sobre las lineas originales pero estoy añadiendo lineas de forma artificial
		
		if($i -gt $lineaInicio1 -and $i -lt $lineaFinal1){
			Write-Host "j" $j "i" $i
			$nuevasLineas[$i] = $datos1[$j]
			$j++
			continue
		}
		else{
		
		
		if($i -gt $lineaInicio2 -and $i -lt $lineaFinal2){
			Write-Host "k" $k "i" $i
			$nuevasLineas[$i] = $datos2[$k]
			$k++
			continue
		}
		else {$nuevasLineas[$i]= $lineas[$i] 
		Write-Host "i" $i
		}}
		
	}
	#Write-Host $nuevasLineas.Length #>
	
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


def seleccionar_datosX(nombre_archivo):
    with open(nombre_archivo, 'r') as f:
        lines = f.readlines()
        print(lines)
    start_line = lines.index("Detector ID\tX Axis Position(cm)\tSet 1\n")+1
    end_line = lines.index("Detector ID\tY Axis Position(cm)\tSet 1\n")

    return [line.replace(',', '.') for line in lines[start_line:end_line]]
  
def seleccionar_datosY(nombre_archivo):
    with open(nombre_archivo, 'r') as f:
        lines = f.readlines()
        #print(lines)
    start_line = lines.index("Detector ID\tY Axis Position(cm)\tSet 1\n")
    end_line = start_line+90
    

    return [line.replace(',', '.') for line in lines[start_line:end_line]]

def insertar_datos(datos1,datos2, nombre_archivo):
    with open(nombre_archivo, 'r') as f:
        lines = f.readlines()
        #print(lines)

    start_line1 = lines.index("\tBEGIN_SCAN  1\n") + 73
    end_line1 = lines.index("\tEND_SCAN  1\n")-2
  
    start_line2 = lines.index("\tBEGIN_SCAN  2\n") + 73
    end_line2 = lines.index("\tEND_SCAN  2\n")-2
    print(lines[start_line1:end_line1],lines[start_line2:end_line2])
    new_lines = lines[:start_line1]
    new_lines.extend(datos1)
    new_lines.extend(lines[end_line1:start_line2])
    new_lines.extend(datos2)
    new_lines.extend(lines[end_line2:])
   
    with open(nombre_archivo, 'w') as f:
        f.writelines(new_lines)


def comparar_archivos(nombre_archivo1, nombre_archivo2):
    with open(nombre_archivo1, 'r') as f:
        contenido1 = f.readlines()

    with open(nombre_archivo2, 'r') as f:
        contenido2 = f.readlines()

    for i, (linea1, linea2) in enumerate(zip(contenido1, contenido2)):
        if linea1 != linea2:
            print(f'La línea {i+1} es diferente en ambos archivos:\n'
                  f'Archivo1: {linea1}\n'
                  f'Archivo2: {linea2}\n')
          
if __name__ == "__main__":
    datosX = seleccionar_datosX('SNC_profiler.txt')
    datosY = seleccionar_datosY('SNC_profiler.txt')
    insertar_datos(datosX,datosY, 'PRUEBA.txt')
   # comparar_archivos('prueba.txt','plantilla_mephysto.txt')
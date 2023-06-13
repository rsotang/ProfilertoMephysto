def seleccionar_datos(nombre_archivo):
    with open(nombre_archivo, 'r') as f:
        lines = f.readlines()
        print(lines)
    start_line = lines.index("Detector ID\tX Axis Position(cm)\tSet 1\n")
    end_line = lines.index("Detector ID\tY Axis Position(cm)\tSet 1\n")

    return [line.replace(',', '.') for line in lines[start_line:end_line]]

def insertar_datos(datos, nombre_archivo):
    with open(nombre_archivo, 'r') as f:
        lines = f.readlines()
        print(lines)

    start_line = lines.index("\t\tBEGIN_DATA\n") + 1
    end_line = lines.index("\t\tEND_DATA\n")

    new_lines = lines[:start_line] + datos + lines[end_line:]

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
    datos = seleccionar_datos('SNC_profiler.txt')
    insertar_datos(datos, 'prueba.txt')
    comparar_archivos('prueba.txt','plantilla_mephysto.txt')
# Automatización de Autoclave
***

## Lista de componentes
| Componente | Cantidad |
| --- | --- |
| Microcontrolador PIC18F4550 | 1 |
| Cristal 4MHz | 1 |
| Capacitor 1nF | 2 |
| Fuente de tensión continua de 5Vdc | 1 |
| Fuente de tensión continua de 24Vdc | 1 |
| Toma de tensión alterna de 110Vac | 1 |
| Pantalla grafica de cristal líquido KS0108 128x64 | 1 |
| Pulsador Normalmente Abierto | 4 |
| Resistencia 10Kohm | 10 | 
| Transistores NPN 2N2222 | 3 |
| Diodo 1N4004 | 3 |
| Relé de 5Vdc | 3 |
| Sensor de nivel de líquidos | 1 |
| Final de carrera | 2 |
| Motor DC de 5v | 1 |
| Driver TB6612 | 1 |
| Puente Rectificador | 1 |
| Capacitor 100nf | 1 |
| Sensor de Temperatura TP100 | 1 |

***
## Funciones
### Función 1:
Al iniciar el sistema, se muestra la imagen de la marca del equipo en la pantalla LCD gráfica, por un corto tiempo. 

### Función 2: 
Se procede a desplegar un menú que permite seleccionar el tipo de material a estilizar. 
1.	Material Descartable
2.	Material Liquido
3.	Material Quirúrgico

### Función 3: 
Al seleccionar el material se establece el tiempo de duración de la esterilización adecuada:  
1.	15min - Descartables
2.	20min - Líquidos
3.	45min - Quirúrgicos

### Función 4:
Se activa la bomba que agregar el agua destilada, y se muestra en pantalla un mensaje “Agregando Agua Destilada”. 

### Función 5: 
Luego de agregar la cantidad de agua destilada suficiente, se activa el motor que mueva el volante giratorio para abrir la puerta del Autoclave. Se muestra un mensaje en la pantalla y se notifica “Colocar materiales dentro de la canastilla”.

### Función 6: 
Al presionar el botón de cerrar, cambia la polaridad del motor y se cierra la puerta del Autoclave. Se muestra en pantalla la temperatura de la Cámara Interior. 

### Función 7:
Al cerrar la puerta, se abre la válvula de purga y se activa la resistencia de calefacción. 

### Función 8: 
Se monitorea la temperatura de la Cámara y se muestra en pantalla en tiempo real. 

### Función 9:
Se muestra además de la temperatura la etapa de purgado. 

### Función 10: 
Después que la temperatura llegue a 121ºC:
1.	Se cierra la válvula de purga
2.	Se activa el temporizador, mostrando en pantalla el conteo del tiempo
3.	Se muestra en pantalla “Etapa de Esterilización”

### Función 11: 
Luego de culminar el tiempo requerido:
1.	Se desactiva la resistencia de calefacción
2.	Se abre la válvula de purgado y muestra en pantalla la temperatura
3.	Se muestra en pantalla “Fase de descarga” hasta que la temperatura sea 0

### Función 12:
Luego del periodo de tiempo de purga se activa el motor que mueve el volante giratorio y deja la puerta semiabierta. Se activa un temporizador por 60 segundos y se muestra un mensaje para que espere 60seg con el contador.

### Función: 
Luego de los 60 segundos Muestra en pantalla “Retirar materiales y Apagar el sistema”.

***
## Esquemático
![Image text](https://github.com/adnahl/automatizacion_autoclave/blob/main/Archivos/Esquematico.bmp)

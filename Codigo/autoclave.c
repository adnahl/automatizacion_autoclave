/*******************************************************************************
AUTOCLAVE
*******************************************************************************/

///Constantes
#define LM35 PORTA.F0

#define btnA PORTA.F1
#define btnB PORTA.F2
#define btnC PORTA.F3

#define bombaAguaDes PORTE.F0
#define valvulaPurga PORTE.F1
#define resistenciaC PORTE.F2

#define nivelAguaDes PORTA.F4

#define IN1  PORTC.F0
#define IN2  PORTC.F1

#define fcPuertaAbierta PORTC.F4
#define fcPuertaCerrada PORTC.F5
#define btnCerrarPuerta PORTB.F7

#define Activar 1
#define Desactivar 0

///Variables
const unsigned short VREF = 5.00; //  VREF Voltaje de Referencia (Fuente 5v)
unsigned int temp_res = 0;
float Temp;
char txtTemp[15];

unsigned int tiempo;  //Almacena el Tiempo en minuto para el ciclo
bit banderaTiempo;    //Bandera que nos indica cuando el Tiempo se ha cumplido
unsigned int cont, setpoint;

//Imagen Logo del Equipo
const code char logo[1024] = {
  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 128, 128, 192, 192,  96,  96,  32,  48,  48,  48,  16,  16,  16,  16,  16,  16,  16,  16,  16,  48,  48,  32,  32,  96,  96, 192, 192, 128, 128,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 128, 192, 224, 112,  48,  56,  28,  14,   7,   3,   1,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   1,   3,   7,  14,  14,  28,  56, 112, 224, 192, 128,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 128, 192, 224, 112,  56,  24,  12,  14,   7,   3,   1,   0,   0,   8,   8,  12,  60, 254, 254, 220, 140,   8,   8,   0,   0,   0,   0,   8,   8,  12,  12,  62, 126, 254, 220, 140,   8,   8,   0,   0,   0,   0,   8,   8,   8,  12,  12, 126, 254, 238, 140, 140,   8,   8,   0,   1,   1,   3,   7,  14,  28,  56, 112, 224, 192, 128, 128,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 128, 128, 192, 224, 112,  56,  28,  14,   6,   3,   3,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   1,   1,   3, 206, 254, 252,   0,   0,   0,   0,   0,   0,   0,   0,   0,   1,   3, 131, 207, 254, 252,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   1,   3, 135, 254, 252,  56,   0,   0,   0,   0,   0,   0,   0,   0,   1,   1,   3,   7,  14,  28,  56,  48,  96, 224, 192, 128,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 224, 240, 120,  28,  14,   7,   3,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 128, 224, 240, 120,  28,  12,   6,   7,   3,   3,   1,   0,   0,   0,   0,   0, 224, 240,  56,  28,  12,   6,   7,   3,   3,   1,   0,   0,   0,   0,   0, 224, 240, 120,  24,  12,  14,   7,   3,   3,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   1,   3,   7,  14,  28, 120, 240, 224,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   7,  15,  30,  56,  48,  32,  96,  96,  64, 192, 192, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 135, 143, 158, 184, 176, 160, 128, 128, 128, 128, 128, 128, 128, 128, 128, 135, 143, 158, 184, 176, 160, 160, 128, 128, 128, 128, 128, 128, 128, 128, 131, 135, 143, 156, 184, 176, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 192, 192,  64,  96,  96,  48,  56,  28,  15,   7,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   1,  33,  49,  49,  25, 249, 249, 249, 249,   1,   1,   1,   1,   1,  25,  25,   9,   9, 137, 153, 217, 249, 241, 113,   1,   1,   1,  33,  49,  49,  49, 249, 249, 249, 249,   1,   1,  57, 121,  73,  73,  73,  73, 121,  49,   1,   1,   1, 225, 241, 241, 113,  57,  25,  25,   9,   9,   9,   9,   9,  25,   1,   1,   1,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   7,   7,   7,   7,   0,   0,   0,   0,   4,   6,   6,   7,   7,   7,   5,   5,   4,   4,   4,   4,   0,   0,   0,   0,   0,   0,   7,   7,   7,   7,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   1,   3,   7,   7,   6,   4,   4,   4,  12,   4,   4,   4,   4,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
};

//-  Configuración para la GLCD modelo KS0108 128x64  -//
// Puerto D: Bus de Datos de la GLCD
char GLCD_DataPort at PORTD;

//Puerto B: Control de la GLCD
sbit GLCD_CS1 at LATB0_bit;
sbit GLCD_CS2 at LATB1_bit;
sbit GLCD_RS  at LATB2_bit;
sbit GLCD_RW  at LATB3_bit;
sbit GLCD_EN  at LATB4_bit;
sbit GLCD_RST at LATB5_bit;

sbit GLCD_CS1_Direction at TRISB0_bit;
sbit GLCD_CS2_Direction at TRISB1_bit;
sbit GLCD_RS_Direction  at TRISB2_bit;
sbit GLCD_RW_Direction  at TRISB3_bit;
sbit GLCD_EN_Direction  at TRISB4_bit;
sbit GLCD_RST_Direction at TRISB5_bit;

////////////////////////////////////////////////////////////////////////////////

//--- Interrupciones ---//

void Interrupt(){
      if (TMR1IF_bit){
          TMR1IF_bit = 0;  //Reiniciamos el Timer
          TMR1H = 0x3C; //Configuramos
          TMR1L = 0xB0; //   el Timer1
          cont++; //Incrementamos el contador cada 100ms
          //Si SETPOINT es igual a 600 implica 1min (600 x 100ms = 1min)
          if (cont == setpoint){
             cont = 0;          //Reiniciamos contador to 0
             banderaTiempo=1;   //Activamos Bandera de Tiempo cumplido

          }
      }
}


//--- Funciones ---//

//--Configuracion Inicial
void configInicial(void){
     ADCON1 = 0x0E;         // Configura todos los puertos Analogos como Digitales
                            //  excepto AN0
     CMCON  = 7;            // Desabilitamos los comparadores
     
     PORTA=0xFF;            //PUERTO A COMO ENTRADA
     TRISA=0xFF;
     PORTC=0xB0;            //PUERTO C 10110000
     TRISC=0xB0;
     TRISE0_bit=0;          //PUERTO E COMO SALIDA
     TRISE1_bit=0;
     TRISE2_bit=0;

     IN1 = 0;
     IN2 = 0;
     
     //TRISA0_bit = 1;       // Configura pin RA0 como Entrada
     ADC_Init();           // Inicializamos ADC
     temp_res = 0;
     
     Glcd_Init();          // Inicializamos GLCD
     delay_ms(500);        // Retardo de 500ms
     Glcd_Fill(0x00);      // Borramos GLCD
}

//--Mostramos el LOGO del equipo
void mostrarLOGO(void){
    Glcd_Image(logo);    // Dibujamos Imagen (Logo del Equipo)
    delay_ms(5000);      // Retardo de 5s                            //*******
}

//--Mostramos MENU
void mostrarMENU(void){
   Glcd_Fill(0x00);        //Borramos GLCD
   Glcd_Write_Text("  SELECIONE MATERIAL", 0, 0, 1); //Escribimos Texto
   Glcd_Write_Text("A: Descartables", 0, 2, 1);
   Glcd_Write_Text("B: Liquidos",     0, 4, 1);
   Glcd_Write_Text("C: Quirurgicos",  0, 6, 1);
}

//Seleccionar Tipo de Material
void seleccion(void){
    int material = 0 ;
    do{
       if (Button(&PORTA, 1, 1, 0)) { //A  //Button(port, pin, time, active_state);
          material=1;
          tiempo = 15;  //15min
       }
       if (Button(&PORTA, 2, 1, 0)) { //B
          material=1;
          tiempo = 20; //20min
       }
       if (Button(&PORTA, 3, 1, 0)) { //C
          material=1;
          tiempo = 45; //45min
       }
       delay_ms(100);
   }while(material!=1);
}

//Activa o Desactiva Bomba de Agua Destilada
void bombaAguaDestilada(int i){
     bombaAguaDes = i;
     if(i){
        Glcd_Fill(0x00); //Borramos GLCD
        Glcd_Write_Text("AGREGANDO", 36, 2, 1); //Escribimos Texto
        Glcd_Write_Text("  AGUA",    36, 3, 1);
        Glcd_Write_Text("DESTILADA", 36, 4, 1);
     }
}

void abrirPuerta(void){
   Glcd_Fill(0x00); //Borramos GLCD
   Glcd_Write_Text("ABRIENDO PUERTA",  18, 3, 1); //Escribimos Texto
   IN1 = 1;
   IN2 = 0;
}

void cerrarPuerta(void){
   Glcd_Fill(0x00); //Borramos GLCD
   Glcd_Write_Text("CERRANDO PUERTA",  18, 3, 1); //Escribimos Texto
   IN1 = 0;
   IN2 = 1;
}

void paraMotorPuerta(void){
     IN1 = 0;
     IN2 = 0;
}

void mostrarTemperatura(void){
    temp_res = ADC_Get_Sample(0);     // Obtiene el resultado 10-bit de
                                      // la conversion AD en VN0
    Temp = (temp_res * VREF)/10.240;  // Calcula la temperatura en Celsuis
    FloatToStr(Temp, txtTemp);        // Convierte la temperatura en texto
    txtTemp[6] = 0;
    Glcd_Write_Text(txtTemp, 46, 2, 1);// Escribe la Temperatura
    delay_ms(100);
}

void valvulaDePurga(int i){
     valvulaPurga = i;
}

void resCalefaccion(int i){
     resistenciaC = i;
}

//Inicializa Temporizador //SERA MODIFICADA PARA USO CON TIMER
void iniTemporizador(int i){
    int intTiempo;
    char txtTiempo[3];
    T1CON = 0x11;
    TMR1IF_bit = 0;
    TMR1H = 0x3C;
    TMR1L = 0xB0;
    TMR1IE_bit = 1;
    INTCON = 0xC0;
    cont=0;
    banderaTiempo=0;
    setpoint = tiempo*600; //SETPOINT Tiempo en segundo

    Glcd_Write_Text("TEMPERATURA EN  C", 13, 1, 1); //Ubicamos en el centro de X
    Glcd_Write_Text_adv("o", 104, 4); //Simulamos el simbolo del grado

    Glcd_Write_Text("TIEMPO RESTANTE", 19, 4, 1); //(128-15*6)/2
    Glcd_Write_Text("       MIN", 19, 5, 1); //19*6=114
    do{
       mostrarTemperatura();
       intTiempo=tiempo-cont/600;
       IntToStr(intTiempo, txtTiempo);
       Glcd_Write_Text(txtTiempo, 12, 5, 1); //17*6=102
       delay_ms(500);
    }while(!banderaTiempo);
}

////////////////////////////////////////////////////////////////////////////////

//-- PROGRAMA PRINCIPAL --//
void main() {
   int j;
   char txtJ[3];          //Variable usada para mostrar retardo final de 60s
   configInicial();       //Configuracion Inicial
   mostrarLOGO();         //Mostramos Logo del Equipo
   mostrarMENU();         //Mostrar Menu
   seleccion();           //Esperamos que seleccione una opción
                          //y asignamos el tiempo
   bombaAguaDestilada(Activar); //Activamos Bomba de Agua Destilada
   while(nivelAguaDes);  //Mientras el nivel de Agua Destilada no sea suficinete
   bombaAguaDestilada(Desactivar); //Desactivamos Bomba de Agua Destilada

   abrirPuerta();          //Abrimos puerta
   while(fcPuertaAbierta); //Mientras La Puerta no este abierta
   paraMotorPuerta();      //Paramos motor que abre/cierra la puerta
   
   Glcd_Fill(0x00); //Borramos GLCD
   Glcd_Write_Text(" COLOCAR MATERIALES",  0, 2, 1); //Escribimos Texto
   Glcd_Write_Text("      DENTRO",         0, 3, 1);
   Glcd_Write_Text("  DE LA CANASTILLA",   0, 4, 1);

   Glcd_Write_Text("...y cerrar la puerta", 0, 7, 1);

   while(btnCerrarPuerta);
   cerrarPuerta();
   while(fcPuertaCerrada);
   paraMotorPuerta();
   
   Glcd_Fill(0x00); //Borramos GLCD
   //mostrarTemperatura();

   valvulaDePurga(Activar);
   resCalefaccion(Activar);

   Glcd_Write_Text("ETAPA: PURGADO",  0, 7, 1);

   Glcd_Write_Text("TEMPERATURA EN  C", 13, 1, 1); //Ubicamos en el centro de X
   Glcd_Write_Text_adv("o", 104, 4); //Simulamos el simbolo del grado
   do{
      mostrarTemperatura();   //Actualizamos lectura de medicon de Temperstura
      delay_ms(5000);         //...cada 5s
   }while(Temp <=121);        //...hasta que la Temp sea menor o igual a 121*C

   valvulaDePurga(Desactivar);

   Glcd_Write_Text("ETAPA: ESTERILIZACION",  0, 7, 1);
   
   iniTemporizador(tiempo);
   while(!banderaTiempo);

   valvulaDePurga(Activar);
   resCalefaccion(Desactivar);
   
   Glcd_Fill(0x00); //Borramos GLCD
   Glcd_Write_Text("ETAPA: FASE DESCARGA",  0, 7, 1);
   Glcd_Write_Text("TEMPERATURA EN  C", 13, 1, 1); //Ubicamos en el centro de X
   Glcd_Write_Text_adv("o", 104, 4); //Simulamos el simbolo del grado
   do{
      mostrarTemperatura();
      delay_ms(5000);
   }while(Temp > 30); //Temperatura Ambiente
   
   valvulaDePurga(Desactivar);
   
   abrirPuerta();
   while(fcPuertaAbierta);
   paraMotorPuerta();
   
   Glcd_Fill(0x00); //Borramos GLCD
   Glcd_Write_Text("ESPERE",  46, 2, 1); //(128-6*6)/2
   Glcd_Write_Text("60 seg",    46, 4, 1);

   for(j=60;j>0;j--){
      delay_ms(1000);
      IntToStr(j, txtJ);
      Glcd_Write_Text(txtJ, 22, 4, 1); //46-24
   }
   
   Glcd_Fill(0x00); //Borramos GLCD
   Glcd_Write_Text("RETIRE OBJETOS",  18, 2, 1);
   Glcd_Write_Text("    DE LA",       18, 3, 1);
   Glcd_Write_Text("  CANASTILLA",    18, 4, 1);
   
   //--- Ciclo infinito
   do{
   
   }while(1);
}
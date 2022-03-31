#line 1 "C:/Users/Adnan/Documents/Automatizacion_AutoClave/Codigo/autoclave.c"
#line 29 "C:/Users/Adnan/Documents/Automatizacion_AutoClave/Codigo/autoclave.c"
const unsigned short VREF = 5.00;
unsigned int temp_res = 0;
float Temp;
char txtTemp[15];

unsigned int tiempo;
bit banderaTiempo;
unsigned int cont, setpoint;


const code char logo[1024] = {
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 128, 192, 192, 96, 96, 32, 48, 48, 48, 16, 16, 16, 16, 16, 16, 16, 16, 16, 48, 48, 32, 32, 96, 96, 192, 192, 128, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 192, 224, 112, 48, 56, 28, 14, 7, 3, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 7, 14, 14, 28, 56, 112, 224, 192, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 192, 224, 112, 56, 24, 12, 14, 7, 3, 1, 0, 0, 8, 8, 12, 60, 254, 254, 220, 140, 8, 8, 0, 0, 0, 0, 8, 8, 12, 12, 62, 126, 254, 220, 140, 8, 8, 0, 0, 0, 0, 8, 8, 8, 12, 12, 126, 254, 238, 140, 140, 8, 8, 0, 1, 1, 3, 7, 14, 28, 56, 112, 224, 192, 128, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 128, 192, 224, 112, 56, 28, 14, 6, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 3, 206, 254, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 131, 207, 254, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 135, 254, 252, 56, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 3, 7, 14, 28, 56, 48, 96, 224, 192, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 224, 240, 120, 28, 14, 7, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 224, 240, 120, 28, 12, 6, 7, 3, 3, 1, 0, 0, 0, 0, 0, 224, 240, 56, 28, 12, 6, 7, 3, 3, 1, 0, 0, 0, 0, 0, 224, 240, 120, 24, 12, 14, 7, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 7, 14, 28, 120, 240, 224, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 15, 30, 56, 48, 32, 96, 96, 64, 192, 192, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 135, 143, 158, 184, 176, 160, 128, 128, 128, 128, 128, 128, 128, 128, 128, 135, 143, 158, 184, 176, 160, 160, 128, 128, 128, 128, 128, 128, 128, 128, 131, 135, 143, 156, 184, 176, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 192, 192, 64, 96, 96, 48, 56, 28, 15, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 33, 49, 49, 25, 249, 249, 249, 249, 1, 1, 1, 1, 1, 25, 25, 9, 9, 137, 153, 217, 249, 241, 113, 1, 1, 1, 33, 49, 49, 49, 249, 249, 249, 249, 1, 1, 57, 121, 73, 73, 73, 73, 121, 49, 1, 1, 1, 225, 241, 241, 113, 57, 25, 25, 9, 9, 9, 9, 9, 25, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7, 7, 0, 0, 0, 0, 4, 6, 6, 7, 7, 7, 5, 5, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 7, 7, 7, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 7, 7, 6, 4, 4, 4, 12, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};



char GLCD_DataPort at PORTD;


sbit GLCD_CS1 at LATB0_bit;
sbit GLCD_CS2 at LATB1_bit;
sbit GLCD_RS at LATB2_bit;
sbit GLCD_RW at LATB3_bit;
sbit GLCD_EN at LATB4_bit;
sbit GLCD_RST at LATB5_bit;

sbit GLCD_CS1_Direction at TRISB0_bit;
sbit GLCD_CS2_Direction at TRISB1_bit;
sbit GLCD_RS_Direction at TRISB2_bit;
sbit GLCD_RW_Direction at TRISB3_bit;
sbit GLCD_EN_Direction at TRISB4_bit;
sbit GLCD_RST_Direction at TRISB5_bit;





void Interrupt(){
 if (TMR1IF_bit){
 TMR1IF_bit = 0;
 TMR1H = 0x3C;
 TMR1L = 0xB0;
 cont++;

 if (cont == setpoint){
 cont = 0;
 banderaTiempo=1;

 }
 }
}





void configInicial(void){
 ADCON1 = 0x0E;

 CMCON = 7;

 PORTA=0xFF;
 TRISA=0xFF;
 PORTC=0xB0;
 TRISC=0xB0;
 TRISE0_bit=0;
 TRISE1_bit=0;
 TRISE2_bit=0;

  PORTC.F0  = 0;
  PORTC.F1  = 0;


 ADC_Init();
 temp_res = 0;

 Glcd_Init();
 delay_ms(500);
 Glcd_Fill(0x00);
}


void mostrarLOGO(void){
 Glcd_Image(logo);
 delay_ms(5000);
}


void mostrarMENU(void){
 Glcd_Fill(0x00);
 Glcd_Write_Text("  SELECIONE MATERIAL", 0, 0, 1);
 Glcd_Write_Text("A: Descartables", 0, 2, 1);
 Glcd_Write_Text("B: Liquidos", 0, 4, 1);
 Glcd_Write_Text("C: Quirurgicos", 0, 6, 1);
}


void seleccion(void){
 int material = 0 ;
 do{
 if (Button(&PORTA, 1, 1, 0)) {
 material=1;
 tiempo = 15;
 }
 if (Button(&PORTA, 2, 1, 0)) {
 material=1;
 tiempo = 20;
 }
 if (Button(&PORTA, 3, 1, 0)) {
 material=1;
 tiempo = 45;
 }
 delay_ms(100);
 }while(material!=1);
}


void bombaAguaDestilada(int i){
  PORTE.F0  = i;
 if(i){
 Glcd_Fill(0x00);
 Glcd_Write_Text("AGREGANDO", 36, 2, 1);
 Glcd_Write_Text("  AGUA", 36, 3, 1);
 Glcd_Write_Text("DESTILADA", 36, 4, 1);
 }
}

void abrirPuerta(void){
 Glcd_Fill(0x00);
 Glcd_Write_Text("ABRIENDO PUERTA", 18, 3, 1);
  PORTC.F0  = 1;
  PORTC.F1  = 0;
}

void cerrarPuerta(void){
 Glcd_Fill(0x00);
 Glcd_Write_Text("CERRANDO PUERTA", 18, 3, 1);
  PORTC.F0  = 0;
  PORTC.F1  = 1;
}

void paraMotorPuerta(void){
  PORTC.F0  = 0;
  PORTC.F1  = 0;
}

void mostrarTemperatura(void){
 temp_res = ADC_Get_Sample(0);

 Temp = (temp_res * VREF)/10.240;
 FloatToStr(Temp, txtTemp);
 txtTemp[6] = 0;
 Glcd_Write_Text(txtTemp, 46, 2, 1);
 delay_ms(100);
}

void valvulaDePurga(int i){
  PORTE.F1  = i;
}

void resCalefaccion(int i){
  PORTE.F2  = i;
}


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
 setpoint = tiempo*600;

 Glcd_Write_Text("TEMPERATURA EN  C", 13, 1, 1);
 Glcd_Write_Text_adv("o", 104, 4);

 Glcd_Write_Text("TIEMPO RESTANTE", 19, 4, 1);
 Glcd_Write_Text("       MIN", 19, 5, 1);
 do{
 mostrarTemperatura();
 intTiempo=tiempo-cont/600;
 IntToStr(intTiempo, txtTiempo);
 Glcd_Write_Text(txtTiempo, 12, 5, 1);
 delay_ms(500);
 }while(!banderaTiempo);
}




void main() {
 int j;
 char txtJ[3];
 configInicial();
 mostrarLOGO();
 mostrarMENU();
 seleccion();

 bombaAguaDestilada( 1 );
 while( PORTA.F4 );
 bombaAguaDestilada( 0 );

 abrirPuerta();
 while( PORTC.F4 );
 paraMotorPuerta();

 Glcd_Fill(0x00);
 Glcd_Write_Text(" COLOCAR MATERIALES", 0, 2, 1);
 Glcd_Write_Text("      DENTRO", 0, 3, 1);
 Glcd_Write_Text("  DE LA CANASTILLA", 0, 4, 1);

 Glcd_Write_Text("...y cerrar la puerta", 0, 7, 1);

 while( PORTB.F7 );
 cerrarPuerta();
 while( PORTC.F5 );
 paraMotorPuerta();

 Glcd_Fill(0x00);


 valvulaDePurga( 1 );
 resCalefaccion( 1 );

 Glcd_Write_Text("ETAPA: PURGADO", 0, 7, 1);

 Glcd_Write_Text("TEMPERATURA EN  C", 13, 1, 1);
 Glcd_Write_Text_adv("o", 104, 4);
 do{
 mostrarTemperatura();
 delay_ms(5000);
 }while(Temp <=121);

 valvulaDePurga( 0 );

 Glcd_Write_Text("ETAPA: ESTERILIZACION", 0, 7, 1);

 iniTemporizador(tiempo);
 while(!banderaTiempo);

 valvulaDePurga( 1 );
 resCalefaccion( 0 );

 Glcd_Fill(0x00);
 Glcd_Write_Text("ETAPA: FASE DESCARGA", 0, 7, 1);
 Glcd_Write_Text("TEMPERATURA EN  C", 13, 1, 1);
 Glcd_Write_Text_adv("o", 104, 4);
 do{
 mostrarTemperatura();
 delay_ms(5000);
 }while(Temp > 30);

 valvulaDePurga( 0 );

 abrirPuerta();
 while( PORTC.F4 );
 paraMotorPuerta();

 Glcd_Fill(0x00);
 Glcd_Write_Text("ESPERE", 46, 2, 1);
 Glcd_Write_Text("60 seg", 46, 4, 1);

 for(j=60;j>0;j--){
 delay_ms(1000);
 IntToStr(j, txtJ);
 Glcd_Write_Text(txtJ, 22, 4, 1);
 }

 Glcd_Fill(0x00);
 Glcd_Write_Text("RETIRE OBJETOS", 18, 2, 1);
 Glcd_Write_Text("    DE LA", 18, 3, 1);
 Glcd_Write_Text("  CANASTILLA", 18, 4, 1);


 do{

 }while(1);
}

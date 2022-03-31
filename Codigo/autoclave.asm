
_Interrupt:

;autoclave.c,73 :: 		void Interrupt(){
;autoclave.c,74 :: 		if (TMR1IF_bit){
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_Interrupt0
;autoclave.c,75 :: 		TMR1IF_bit = 0;  //Reiniciamos el Timer
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;autoclave.c,76 :: 		TMR1H = 0x3C; //Configuramos
	MOVLW       60
	MOVWF       TMR1H+0 
;autoclave.c,77 :: 		TMR1L = 0xB0; //   el Timer1
	MOVLW       176
	MOVWF       TMR1L+0 
;autoclave.c,78 :: 		cont++; //Incrementamos el contador cada 100ms
	INFSNZ      _cont+0, 1 
	INCF        _cont+1, 1 
;autoclave.c,80 :: 		if (cont == setpoint){
	MOVF        _cont+1, 0 
	XORWF       _setpoint+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Interrupt46
	MOVF        _setpoint+0, 0 
	XORWF       _cont+0, 0 
L__Interrupt46:
	BTFSS       STATUS+0, 2 
	GOTO        L_Interrupt1
;autoclave.c,81 :: 		cont = 0;          //Reiniciamos contador to 0
	CLRF        _cont+0 
	CLRF        _cont+1 
;autoclave.c,82 :: 		banderaTiempo=1;   //Activamos Bandera de Tiempo cumplido
	BSF         _banderaTiempo+0, BitPos(_banderaTiempo+0) 
;autoclave.c,84 :: 		}
L_Interrupt1:
;autoclave.c,85 :: 		}
L_Interrupt0:
;autoclave.c,86 :: 		}
L_end_Interrupt:
L__Interrupt45:
	RETFIE      1
; end of _Interrupt

_configInicial:

;autoclave.c,92 :: 		void configInicial(void){
;autoclave.c,93 :: 		ADCON1 = 0x0E;         // Configura todos los puertos Analogos como Digitales
	MOVLW       14
	MOVWF       ADCON1+0 
;autoclave.c,95 :: 		CMCON  = 7;            // Desabilitamos los comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;autoclave.c,97 :: 		PORTA=0xFF;            //PUERTO A COMO ENTRADA
	MOVLW       255
	MOVWF       PORTA+0 
;autoclave.c,98 :: 		TRISA=0xFF;
	MOVLW       255
	MOVWF       TRISA+0 
;autoclave.c,99 :: 		PORTC=0xB0;            //PUERTO C 10110000
	MOVLW       176
	MOVWF       PORTC+0 
;autoclave.c,100 :: 		TRISC=0xB0;
	MOVLW       176
	MOVWF       TRISC+0 
;autoclave.c,101 :: 		TRISE0_bit=0;          //PUERTO E COMO SALIDA
	BCF         TRISE0_bit+0, BitPos(TRISE0_bit+0) 
;autoclave.c,102 :: 		TRISE1_bit=0;
	BCF         TRISE1_bit+0, BitPos(TRISE1_bit+0) 
;autoclave.c,103 :: 		TRISE2_bit=0;
	BCF         TRISE2_bit+0, BitPos(TRISE2_bit+0) 
;autoclave.c,105 :: 		IN1 = 0;
	BCF         PORTC+0, 0 
;autoclave.c,106 :: 		IN2 = 0;
	BCF         PORTC+0, 1 
;autoclave.c,109 :: 		ADC_Init();           // Inicializamos ADC
	CALL        _ADC_Init+0, 0
;autoclave.c,110 :: 		temp_res = 0;
	CLRF        _temp_res+0 
	CLRF        _temp_res+1 
;autoclave.c,112 :: 		Glcd_Init();          // Inicializamos GLCD
	CALL        _Glcd_Init+0, 0
;autoclave.c,113 :: 		delay_ms(500);        // Retardo de 500ms
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_configInicial2:
	DECFSZ      R13, 1, 1
	BRA         L_configInicial2
	DECFSZ      R12, 1, 1
	BRA         L_configInicial2
	DECFSZ      R11, 1, 1
	BRA         L_configInicial2
	NOP
	NOP
;autoclave.c,114 :: 		Glcd_Fill(0x00);      // Borramos GLCD
	CLRF        FARG_Glcd_Fill_pattern+0 
	CALL        _Glcd_Fill+0, 0
;autoclave.c,115 :: 		}
L_end_configInicial:
	RETURN      0
; end of _configInicial

_mostrarLOGO:

;autoclave.c,118 :: 		void mostrarLOGO(void){
;autoclave.c,119 :: 		Glcd_Image(logo);    // Dibujamos Imagen (Logo del Equipo)
	MOVLW       _logo+0
	MOVWF       FARG_Glcd_Image_image+0 
	MOVLW       hi_addr(_logo+0)
	MOVWF       FARG_Glcd_Image_image+1 
	MOVLW       higher_addr(_logo+0)
	MOVWF       FARG_Glcd_Image_image+2 
	CALL        _Glcd_Image+0, 0
;autoclave.c,120 :: 		delay_ms(5000);      // Retardo de 5s                            //*******
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_mostrarLOGO3:
	DECFSZ      R13, 1, 1
	BRA         L_mostrarLOGO3
	DECFSZ      R12, 1, 1
	BRA         L_mostrarLOGO3
	DECFSZ      R11, 1, 1
	BRA         L_mostrarLOGO3
	NOP
;autoclave.c,121 :: 		}
L_end_mostrarLOGO:
	RETURN      0
; end of _mostrarLOGO

_mostrarMENU:

;autoclave.c,124 :: 		void mostrarMENU(void){
;autoclave.c,125 :: 		Glcd_Fill(0x00);        //Borramos GLCD
	CLRF        FARG_Glcd_Fill_pattern+0 
	CALL        _Glcd_Fill+0, 0
;autoclave.c,126 :: 		Glcd_Write_Text("  SELECIONE MATERIAL", 0, 0, 1); //Escribimos Texto
	MOVLW       ?lstr1_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr1_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	CLRF        FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,127 :: 		Glcd_Write_Text("A: Descartables", 0, 2, 1);
	MOVLW       ?lstr2_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr2_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       2
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,128 :: 		Glcd_Write_Text("B: Liquidos",     0, 4, 1);
	MOVLW       ?lstr3_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr3_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       4
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,129 :: 		Glcd_Write_Text("C: Quirurgicos",  0, 6, 1);
	MOVLW       ?lstr4_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr4_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       6
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,130 :: 		}
L_end_mostrarMENU:
	RETURN      0
; end of _mostrarMENU

_seleccion:

;autoclave.c,133 :: 		void seleccion(void){
;autoclave.c,134 :: 		int material = 0 ;
	CLRF        seleccion_material_L0+0 
	CLRF        seleccion_material_L0+1 
;autoclave.c,135 :: 		do{
L_seleccion4:
;autoclave.c,136 :: 		if (Button(&PORTA, 1, 1, 0)) { //A  //Button(port, pin, time, active_state);
	MOVLW       PORTA+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTA+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_seleccion7
;autoclave.c,137 :: 		material=1;
	MOVLW       1
	MOVWF       seleccion_material_L0+0 
	MOVLW       0
	MOVWF       seleccion_material_L0+1 
;autoclave.c,138 :: 		tiempo = 15;  //15min
	MOVLW       15
	MOVWF       _tiempo+0 
	MOVLW       0
	MOVWF       _tiempo+1 
;autoclave.c,139 :: 		}
L_seleccion7:
;autoclave.c,140 :: 		if (Button(&PORTA, 2, 1, 0)) { //B
	MOVLW       PORTA+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTA+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_seleccion8
;autoclave.c,141 :: 		material=1;
	MOVLW       1
	MOVWF       seleccion_material_L0+0 
	MOVLW       0
	MOVWF       seleccion_material_L0+1 
;autoclave.c,142 :: 		tiempo = 20; //20min
	MOVLW       20
	MOVWF       _tiempo+0 
	MOVLW       0
	MOVWF       _tiempo+1 
;autoclave.c,143 :: 		}
L_seleccion8:
;autoclave.c,144 :: 		if (Button(&PORTA, 3, 1, 0)) { //C
	MOVLW       PORTA+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTA+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       3
	MOVWF       FARG_Button_pin+0 
	MOVLW       1
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_seleccion9
;autoclave.c,145 :: 		material=1;
	MOVLW       1
	MOVWF       seleccion_material_L0+0 
	MOVLW       0
	MOVWF       seleccion_material_L0+1 
;autoclave.c,146 :: 		tiempo = 45; //45min
	MOVLW       45
	MOVWF       _tiempo+0 
	MOVLW       0
	MOVWF       _tiempo+1 
;autoclave.c,147 :: 		}
L_seleccion9:
;autoclave.c,148 :: 		delay_ms(100);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_seleccion10:
	DECFSZ      R13, 1, 1
	BRA         L_seleccion10
	DECFSZ      R12, 1, 1
	BRA         L_seleccion10
	NOP
	NOP
;autoclave.c,149 :: 		}while(material!=1);
	MOVLW       0
	XORWF       seleccion_material_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__seleccion51
	MOVLW       1
	XORWF       seleccion_material_L0+0, 0 
L__seleccion51:
	BTFSS       STATUS+0, 2 
	GOTO        L_seleccion4
;autoclave.c,150 :: 		}
L_end_seleccion:
	RETURN      0
; end of _seleccion

_bombaAguaDestilada:

;autoclave.c,153 :: 		void bombaAguaDestilada(int i){
;autoclave.c,154 :: 		bombaAguaDes = i;
	BTFSC       FARG_bombaAguaDestilada_i+0, 0 
	GOTO        L__bombaAguaDestilada53
	BCF         PORTE+0, 0 
	GOTO        L__bombaAguaDestilada54
L__bombaAguaDestilada53:
	BSF         PORTE+0, 0 
L__bombaAguaDestilada54:
;autoclave.c,155 :: 		if(i){
	MOVF        FARG_bombaAguaDestilada_i+0, 0 
	IORWF       FARG_bombaAguaDestilada_i+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_bombaAguaDestilada11
;autoclave.c,156 :: 		Glcd_Fill(0x00); //Borramos GLCD
	CLRF        FARG_Glcd_Fill_pattern+0 
	CALL        _Glcd_Fill+0, 0
;autoclave.c,157 :: 		Glcd_Write_Text("AGREGANDO", 36, 2, 1); //Escribimos Texto
	MOVLW       ?lstr5_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr5_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       36
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       2
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,158 :: 		Glcd_Write_Text("  AGUA",    36, 3, 1);
	MOVLW       ?lstr6_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr6_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       36
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       3
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,159 :: 		Glcd_Write_Text("DESTILADA", 36, 4, 1);
	MOVLW       ?lstr7_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr7_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       36
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       4
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,160 :: 		}
L_bombaAguaDestilada11:
;autoclave.c,161 :: 		}
L_end_bombaAguaDestilada:
	RETURN      0
; end of _bombaAguaDestilada

_abrirPuerta:

;autoclave.c,163 :: 		void abrirPuerta(void){
;autoclave.c,164 :: 		Glcd_Fill(0x00); //Borramos GLCD
	CLRF        FARG_Glcd_Fill_pattern+0 
	CALL        _Glcd_Fill+0, 0
;autoclave.c,165 :: 		Glcd_Write_Text("ABRIENDO PUERTA",  18, 3, 1); //Escribimos Texto
	MOVLW       ?lstr8_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr8_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       18
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       3
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,166 :: 		IN1 = 1;
	BSF         PORTC+0, 0 
;autoclave.c,167 :: 		IN2 = 0;
	BCF         PORTC+0, 1 
;autoclave.c,168 :: 		}
L_end_abrirPuerta:
	RETURN      0
; end of _abrirPuerta

_cerrarPuerta:

;autoclave.c,170 :: 		void cerrarPuerta(void){
;autoclave.c,171 :: 		Glcd_Fill(0x00); //Borramos GLCD
	CLRF        FARG_Glcd_Fill_pattern+0 
	CALL        _Glcd_Fill+0, 0
;autoclave.c,172 :: 		Glcd_Write_Text("CERRANDO PUERTA",  18, 3, 1); //Escribimos Texto
	MOVLW       ?lstr9_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr9_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       18
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       3
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,173 :: 		IN1 = 0;
	BCF         PORTC+0, 0 
;autoclave.c,174 :: 		IN2 = 1;
	BSF         PORTC+0, 1 
;autoclave.c,175 :: 		}
L_end_cerrarPuerta:
	RETURN      0
; end of _cerrarPuerta

_paraMotorPuerta:

;autoclave.c,177 :: 		void paraMotorPuerta(void){
;autoclave.c,178 :: 		IN1 = 0;
	BCF         PORTC+0, 0 
;autoclave.c,179 :: 		IN2 = 0;
	BCF         PORTC+0, 1 
;autoclave.c,180 :: 		}
L_end_paraMotorPuerta:
	RETURN      0
; end of _paraMotorPuerta

_mostrarTemperatura:

;autoclave.c,182 :: 		void mostrarTemperatura(void){
;autoclave.c,183 :: 		temp_res = ADC_Get_Sample(0);     // Obtiene el resultado 10-bit de
	CLRF        FARG_ADC_Get_Sample_channel+0 
	CALL        _ADC_Get_Sample+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_res+0 
	MOVF        R1, 0 
	MOVWF       _temp_res+1 
;autoclave.c,185 :: 		Temp = (temp_res * VREF)/10.240;  // Calcula la temperatura en Celsuis
	MOVLW       5
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	CALL        _word2double+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       215
	MOVWF       R5 
	MOVLW       35
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _Temp+0 
	MOVF        R1, 0 
	MOVWF       _Temp+1 
	MOVF        R2, 0 
	MOVWF       _Temp+2 
	MOVF        R3, 0 
	MOVWF       _Temp+3 
;autoclave.c,186 :: 		FloatToStr(Temp, txtTemp);        // Convierte la temperatura en texto
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txtTemp+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txtTemp+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;autoclave.c,187 :: 		txtTemp[6] = 0;
	CLRF        _txtTemp+6 
;autoclave.c,188 :: 		Glcd_Write_Text(txtTemp, 46, 2, 1);// Escribe la Temperatura
	MOVLW       _txtTemp+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(_txtTemp+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       46
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       2
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,189 :: 		delay_ms(100);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_mostrarTemperatura12:
	DECFSZ      R13, 1, 1
	BRA         L_mostrarTemperatura12
	DECFSZ      R12, 1, 1
	BRA         L_mostrarTemperatura12
	NOP
	NOP
;autoclave.c,190 :: 		}
L_end_mostrarTemperatura:
	RETURN      0
; end of _mostrarTemperatura

_valvulaDePurga:

;autoclave.c,192 :: 		void valvulaDePurga(int i){
;autoclave.c,193 :: 		valvulaPurga = i;
	BTFSC       FARG_valvulaDePurga_i+0, 0 
	GOTO        L__valvulaDePurga60
	BCF         PORTE+0, 1 
	GOTO        L__valvulaDePurga61
L__valvulaDePurga60:
	BSF         PORTE+0, 1 
L__valvulaDePurga61:
;autoclave.c,194 :: 		}
L_end_valvulaDePurga:
	RETURN      0
; end of _valvulaDePurga

_resCalefaccion:

;autoclave.c,196 :: 		void resCalefaccion(int i){
;autoclave.c,197 :: 		resistenciaC = i;
	BTFSC       FARG_resCalefaccion_i+0, 0 
	GOTO        L__resCalefaccion63
	BCF         PORTE+0, 2 
	GOTO        L__resCalefaccion64
L__resCalefaccion63:
	BSF         PORTE+0, 2 
L__resCalefaccion64:
;autoclave.c,198 :: 		}
L_end_resCalefaccion:
	RETURN      0
; end of _resCalefaccion

_iniTemporizador:

;autoclave.c,201 :: 		void iniTemporizador(int i){
;autoclave.c,204 :: 		T1CON = 0x11;
	MOVLW       17
	MOVWF       T1CON+0 
;autoclave.c,205 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;autoclave.c,206 :: 		TMR1H = 0x3C;
	MOVLW       60
	MOVWF       TMR1H+0 
;autoclave.c,207 :: 		TMR1L = 0xB0;
	MOVLW       176
	MOVWF       TMR1L+0 
;autoclave.c,208 :: 		TMR1IE_bit = 1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;autoclave.c,209 :: 		INTCON = 0xC0;
	MOVLW       192
	MOVWF       INTCON+0 
;autoclave.c,210 :: 		cont=0;
	CLRF        _cont+0 
	CLRF        _cont+1 
;autoclave.c,211 :: 		banderaTiempo=0;
	BCF         _banderaTiempo+0, BitPos(_banderaTiempo+0) 
;autoclave.c,212 :: 		setpoint = tiempo*600; //SETPOINT Tiempo en segundo
	MOVF        _tiempo+0, 0 
	MOVWF       R0 
	MOVF        _tiempo+1, 0 
	MOVWF       R1 
	MOVLW       88
	MOVWF       R4 
	MOVLW       2
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _setpoint+0 
	MOVF        R1, 0 
	MOVWF       _setpoint+1 
;autoclave.c,214 :: 		Glcd_Write_Text("TEMPERATURA EN  C", 13, 1, 1); //Ubicamos en el centro de X
	MOVLW       ?lstr10_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr10_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       13
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,215 :: 		Glcd_Write_Text_adv("o", 104, 4); //Simulamos el simbolo del grado
	MOVLW       ?lstr11_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_Adv_text+0 
	MOVLW       hi_addr(?lstr11_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_Adv_text+1 
	MOVLW       104
	MOVWF       FARG_Glcd_Write_Text_Adv_x+0 
	MOVLW       0
	MOVWF       FARG_Glcd_Write_Text_Adv_x+1 
	MOVLW       4
	MOVWF       FARG_Glcd_Write_Text_Adv_y+0 
	MOVLW       0
	MOVWF       FARG_Glcd_Write_Text_Adv_y+1 
	CALL        _Glcd_Write_Text_Adv+0, 0
;autoclave.c,217 :: 		Glcd_Write_Text("TIEMPO RESTANTE", 19, 4, 1); //(128-15*6)/2
	MOVLW       ?lstr12_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr12_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       19
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       4
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,218 :: 		Glcd_Write_Text("       MIN", 19, 5, 1); //19*6=114
	MOVLW       ?lstr13_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr13_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       19
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       5
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,219 :: 		do{
L_iniTemporizador13:
;autoclave.c,220 :: 		mostrarTemperatura();
	CALL        _mostrarTemperatura+0, 0
;autoclave.c,221 :: 		intTiempo=tiempo-cont/600;
	MOVLW       88
	MOVWF       R4 
	MOVLW       2
	MOVWF       R5 
	MOVF        _cont+0, 0 
	MOVWF       R0 
	MOVF        _cont+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	SUBWF       _tiempo+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	SUBWFB      _tiempo+1, 0 
	MOVWF       FARG_IntToStr_input+1 
;autoclave.c,222 :: 		IntToStr(intTiempo, txtTiempo);
	MOVLW       iniTemporizador_txtTiempo_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(iniTemporizador_txtTiempo_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;autoclave.c,223 :: 		Glcd_Write_Text(txtTiempo, 12, 5, 1); //17*6=102
	MOVLW       iniTemporizador_txtTiempo_L0+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(iniTemporizador_txtTiempo_L0+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       12
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       5
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,224 :: 		delay_ms(500);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_iniTemporizador16:
	DECFSZ      R13, 1, 1
	BRA         L_iniTemporizador16
	DECFSZ      R12, 1, 1
	BRA         L_iniTemporizador16
	DECFSZ      R11, 1, 1
	BRA         L_iniTemporizador16
	NOP
	NOP
;autoclave.c,225 :: 		}while(!banderaTiempo);
	BTFSS       _banderaTiempo+0, BitPos(_banderaTiempo+0) 
	GOTO        L_iniTemporizador13
;autoclave.c,226 :: 		}
L_end_iniTemporizador:
	RETURN      0
; end of _iniTemporizador

_main:

;autoclave.c,231 :: 		void main() {
;autoclave.c,234 :: 		configInicial();       //Configuracion Inicial
	CALL        _configInicial+0, 0
;autoclave.c,235 :: 		mostrarLOGO();         //Mostramos Logo del Equipo
	CALL        _mostrarLOGO+0, 0
;autoclave.c,236 :: 		mostrarMENU();         //Mostrar Menu
	CALL        _mostrarMENU+0, 0
;autoclave.c,237 :: 		seleccion();           //Esperamos que seleccione una opción
	CALL        _seleccion+0, 0
;autoclave.c,239 :: 		bombaAguaDestilada(Activar); //Activamos Bomba de Agua Destilada
	MOVLW       1
	MOVWF       FARG_bombaAguaDestilada_i+0 
	MOVLW       0
	MOVWF       FARG_bombaAguaDestilada_i+1 
	CALL        _bombaAguaDestilada+0, 0
;autoclave.c,240 :: 		while(nivelAguaDes);  //Mientras el nivel de Agua Destilada no sea suficinete
L_main17:
	BTFSS       PORTA+0, 4 
	GOTO        L_main18
	GOTO        L_main17
L_main18:
;autoclave.c,241 :: 		bombaAguaDestilada(Desactivar); //Desactivamos Bomba de Agua Destilada
	CLRF        FARG_bombaAguaDestilada_i+0 
	CLRF        FARG_bombaAguaDestilada_i+1 
	CALL        _bombaAguaDestilada+0, 0
;autoclave.c,243 :: 		abrirPuerta();          //Abrimos puerta
	CALL        _abrirPuerta+0, 0
;autoclave.c,244 :: 		while(fcPuertaAbierta); //Mientras La Puerta no este abierta
L_main19:
	BTFSS       PORTC+0, 4 
	GOTO        L_main20
	GOTO        L_main19
L_main20:
;autoclave.c,245 :: 		paraMotorPuerta();      //Paramos motor que abre/cierra la puerta
	CALL        _paraMotorPuerta+0, 0
;autoclave.c,247 :: 		Glcd_Fill(0x00); //Borramos GLCD
	CLRF        FARG_Glcd_Fill_pattern+0 
	CALL        _Glcd_Fill+0, 0
;autoclave.c,248 :: 		Glcd_Write_Text(" COLOCAR MATERIALES",  0, 2, 1); //Escribimos Texto
	MOVLW       ?lstr14_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr14_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       2
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,249 :: 		Glcd_Write_Text("      DENTRO",         0, 3, 1);
	MOVLW       ?lstr15_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr15_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       3
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,250 :: 		Glcd_Write_Text("  DE LA CANASTILLA",   0, 4, 1);
	MOVLW       ?lstr16_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr16_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       4
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,252 :: 		Glcd_Write_Text("...y cerrar la puerta", 0, 7, 1);
	MOVLW       ?lstr17_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr17_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       7
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,254 :: 		while(btnCerrarPuerta);
L_main21:
	BTFSS       PORTB+0, 7 
	GOTO        L_main22
	GOTO        L_main21
L_main22:
;autoclave.c,255 :: 		cerrarPuerta();
	CALL        _cerrarPuerta+0, 0
;autoclave.c,256 :: 		while(fcPuertaCerrada);
L_main23:
	BTFSS       PORTC+0, 5 
	GOTO        L_main24
	GOTO        L_main23
L_main24:
;autoclave.c,257 :: 		paraMotorPuerta();
	CALL        _paraMotorPuerta+0, 0
;autoclave.c,259 :: 		Glcd_Fill(0x00); //Borramos GLCD
	CLRF        FARG_Glcd_Fill_pattern+0 
	CALL        _Glcd_Fill+0, 0
;autoclave.c,262 :: 		valvulaDePurga(Activar);
	MOVLW       1
	MOVWF       FARG_valvulaDePurga_i+0 
	MOVLW       0
	MOVWF       FARG_valvulaDePurga_i+1 
	CALL        _valvulaDePurga+0, 0
;autoclave.c,263 :: 		resCalefaccion(Activar);
	MOVLW       1
	MOVWF       FARG_resCalefaccion_i+0 
	MOVLW       0
	MOVWF       FARG_resCalefaccion_i+1 
	CALL        _resCalefaccion+0, 0
;autoclave.c,265 :: 		Glcd_Write_Text("ETAPA: PURGADO",  0, 7, 1);
	MOVLW       ?lstr18_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr18_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       7
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,267 :: 		Glcd_Write_Text("TEMPERATURA EN  C", 13, 1, 1); //Ubicamos en el centro de X
	MOVLW       ?lstr19_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr19_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       13
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,268 :: 		Glcd_Write_Text_adv("o", 104, 4); //Simulamos el simbolo del grado
	MOVLW       ?lstr20_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_Adv_text+0 
	MOVLW       hi_addr(?lstr20_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_Adv_text+1 
	MOVLW       104
	MOVWF       FARG_Glcd_Write_Text_Adv_x+0 
	MOVLW       0
	MOVWF       FARG_Glcd_Write_Text_Adv_x+1 
	MOVLW       4
	MOVWF       FARG_Glcd_Write_Text_Adv_y+0 
	MOVLW       0
	MOVWF       FARG_Glcd_Write_Text_Adv_y+1 
	CALL        _Glcd_Write_Text_Adv+0, 0
;autoclave.c,269 :: 		do{
L_main25:
;autoclave.c,270 :: 		mostrarTemperatura();   //Actualizamos lectura de medicon de Temperstura
	CALL        _mostrarTemperatura+0, 0
;autoclave.c,271 :: 		delay_ms(5000);         //...cada 5s
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main28:
	DECFSZ      R13, 1, 1
	BRA         L_main28
	DECFSZ      R12, 1, 1
	BRA         L_main28
	DECFSZ      R11, 1, 1
	BRA         L_main28
	NOP
;autoclave.c,272 :: 		}while(Temp <=121);        //...hasta que la Temp sea menor o igual a 121*C
	MOVF        _Temp+0, 0 
	MOVWF       R4 
	MOVF        _Temp+1, 0 
	MOVWF       R5 
	MOVF        _Temp+2, 0 
	MOVWF       R6 
	MOVF        _Temp+3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       114
	MOVWF       R2 
	MOVLW       133
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main25
;autoclave.c,274 :: 		valvulaDePurga(Desactivar);
	CLRF        FARG_valvulaDePurga_i+0 
	CLRF        FARG_valvulaDePurga_i+1 
	CALL        _valvulaDePurga+0, 0
;autoclave.c,276 :: 		Glcd_Write_Text("ETAPA: ESTERILIZACION",  0, 7, 1);
	MOVLW       ?lstr21_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr21_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       7
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,278 :: 		iniTemporizador(tiempo);
	MOVF        _tiempo+0, 0 
	MOVWF       FARG_iniTemporizador_i+0 
	MOVF        _tiempo+1, 0 
	MOVWF       FARG_iniTemporizador_i+1 
	CALL        _iniTemporizador+0, 0
;autoclave.c,279 :: 		while(!banderaTiempo);
L_main29:
	BTFSC       _banderaTiempo+0, BitPos(_banderaTiempo+0) 
	GOTO        L_main30
	GOTO        L_main29
L_main30:
;autoclave.c,281 :: 		valvulaDePurga(Activar);
	MOVLW       1
	MOVWF       FARG_valvulaDePurga_i+0 
	MOVLW       0
	MOVWF       FARG_valvulaDePurga_i+1 
	CALL        _valvulaDePurga+0, 0
;autoclave.c,282 :: 		resCalefaccion(Desactivar);
	CLRF        FARG_resCalefaccion_i+0 
	CLRF        FARG_resCalefaccion_i+1 
	CALL        _resCalefaccion+0, 0
;autoclave.c,284 :: 		Glcd_Fill(0x00); //Borramos GLCD
	CLRF        FARG_Glcd_Fill_pattern+0 
	CALL        _Glcd_Fill+0, 0
;autoclave.c,285 :: 		Glcd_Write_Text("ETAPA: FASE DESCARGA",  0, 7, 1);
	MOVLW       ?lstr22_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr22_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	CLRF        FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       7
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,286 :: 		Glcd_Write_Text("TEMPERATURA EN  C", 13, 1, 1); //Ubicamos en el centro de X
	MOVLW       ?lstr23_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr23_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       13
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,287 :: 		Glcd_Write_Text_adv("o", 104, 4); //Simulamos el simbolo del grado
	MOVLW       ?lstr24_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_Adv_text+0 
	MOVLW       hi_addr(?lstr24_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_Adv_text+1 
	MOVLW       104
	MOVWF       FARG_Glcd_Write_Text_Adv_x+0 
	MOVLW       0
	MOVWF       FARG_Glcd_Write_Text_Adv_x+1 
	MOVLW       4
	MOVWF       FARG_Glcd_Write_Text_Adv_y+0 
	MOVLW       0
	MOVWF       FARG_Glcd_Write_Text_Adv_y+1 
	CALL        _Glcd_Write_Text_Adv+0, 0
;autoclave.c,288 :: 		do{
L_main31:
;autoclave.c,289 :: 		mostrarTemperatura();
	CALL        _mostrarTemperatura+0, 0
;autoclave.c,290 :: 		delay_ms(5000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_main34:
	DECFSZ      R13, 1, 1
	BRA         L_main34
	DECFSZ      R12, 1, 1
	BRA         L_main34
	DECFSZ      R11, 1, 1
	BRA         L_main34
	NOP
;autoclave.c,291 :: 		}while(Temp > 30); //Temperatura Ambiente
	MOVF        _Temp+0, 0 
	MOVWF       R4 
	MOVF        _Temp+1, 0 
	MOVWF       R5 
	MOVF        _Temp+2, 0 
	MOVWF       R6 
	MOVF        _Temp+3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       112
	MOVWF       R2 
	MOVLW       131
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main31
;autoclave.c,293 :: 		valvulaDePurga(Desactivar);
	CLRF        FARG_valvulaDePurga_i+0 
	CLRF        FARG_valvulaDePurga_i+1 
	CALL        _valvulaDePurga+0, 0
;autoclave.c,295 :: 		abrirPuerta();
	CALL        _abrirPuerta+0, 0
;autoclave.c,296 :: 		while(fcPuertaAbierta);
L_main35:
	BTFSS       PORTC+0, 4 
	GOTO        L_main36
	GOTO        L_main35
L_main36:
;autoclave.c,297 :: 		paraMotorPuerta();
	CALL        _paraMotorPuerta+0, 0
;autoclave.c,299 :: 		Glcd_Fill(0x00); //Borramos GLCD
	CLRF        FARG_Glcd_Fill_pattern+0 
	CALL        _Glcd_Fill+0, 0
;autoclave.c,300 :: 		Glcd_Write_Text("ESPERE",  46, 2, 1); //(128-6*6)/2
	MOVLW       ?lstr25_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr25_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       46
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       2
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,301 :: 		Glcd_Write_Text("60 seg",    46, 4, 1);
	MOVLW       ?lstr26_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr26_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       46
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       4
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,303 :: 		for(j=60;j>0;j--){
	MOVLW       60
	MOVWF       main_j_L0+0 
	MOVLW       0
	MOVWF       main_j_L0+1 
L_main37:
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       main_j_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main67
	MOVF        main_j_L0+0, 0 
	SUBLW       0
L__main67:
	BTFSC       STATUS+0, 0 
	GOTO        L_main38
;autoclave.c,304 :: 		delay_ms(1000);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main40:
	DECFSZ      R13, 1, 1
	BRA         L_main40
	DECFSZ      R12, 1, 1
	BRA         L_main40
	DECFSZ      R11, 1, 1
	BRA         L_main40
	NOP
	NOP
;autoclave.c,305 :: 		IntToStr(j, txtJ);
	MOVF        main_j_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        main_j_L0+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_txtJ_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_txtJ_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;autoclave.c,306 :: 		Glcd_Write_Text(txtJ, 22, 4, 1); //46-24
	MOVLW       main_txtJ_L0+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(main_txtJ_L0+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       22
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       4
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,303 :: 		for(j=60;j>0;j--){
	MOVLW       1
	SUBWF       main_j_L0+0, 1 
	MOVLW       0
	SUBWFB      main_j_L0+1, 1 
;autoclave.c,307 :: 		}
	GOTO        L_main37
L_main38:
;autoclave.c,309 :: 		Glcd_Fill(0x00); //Borramos GLCD
	CLRF        FARG_Glcd_Fill_pattern+0 
	CALL        _Glcd_Fill+0, 0
;autoclave.c,310 :: 		Glcd_Write_Text("RETIRE OBJETOS",  18, 2, 1);
	MOVLW       ?lstr27_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr27_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       18
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       2
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,311 :: 		Glcd_Write_Text("    DE LA",       18, 3, 1);
	MOVLW       ?lstr28_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr28_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       18
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       3
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,312 :: 		Glcd_Write_Text("  CANASTILLA",    18, 4, 1);
	MOVLW       ?lstr29_autoclave+0
	MOVWF       FARG_Glcd_Write_Text_text+0 
	MOVLW       hi_addr(?lstr29_autoclave+0)
	MOVWF       FARG_Glcd_Write_Text_text+1 
	MOVLW       18
	MOVWF       FARG_Glcd_Write_Text_x_pos+0 
	MOVLW       4
	MOVWF       FARG_Glcd_Write_Text_page_num+0 
	MOVLW       1
	MOVWF       FARG_Glcd_Write_Text_color+0 
	CALL        _Glcd_Write_Text+0, 0
;autoclave.c,315 :: 		do{
L_main41:
;autoclave.c,317 :: 		}while(1);
	GOTO        L_main41
;autoclave.c,318 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

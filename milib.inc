;//////////////////////////////////////////////////////
; Procedimiento: strlne                            
;                                                  
; Parámetros: 
;   Entrada: DX = Dirección de inicio de la cadena
;   Salida:  CX = Cantidad de caracteres en la cadena
;                                                  
; Descripción: Devuelve la cantidad de caracteres en  
;              la cadena cuyo apuntador está dado por DX
;              Debe tomarse en cuenta que se retorna la
;              cantidad total de caracteres - 1 ya que
;              el caracter 0 no se cuenta dentro del total
;              de caracteres visibles.
;                                                  
;//////////////////////////////////////////////////////

extrn strlen:near

;//////////////////////////////////////////////////////
; Procedimiento: puts                            
;                                                  
; Parámetros: 
;   Entrada: DX = Dirección efectiva de la cadena
;   Salida:  Ninguno
;                                                  
; Descripción: Imprime una cadena a partir de la  
;              dirección dada por el registro DX   
;              hasta que se encuentre con un caracter   
;              nulo (terminación en 0). Hace uso de la
;              interrupción 21h, servicio 2 para
;              impresión de caracteres.
;                                                  
;//////////////////////////////////////////////////////

extrn puts:near

;////////////////////////////////////////////////////////////
; Procedimiento: prntBase
; 
; Parámetros: 
;   Entrada:  AX = Número a imprimir
;             BX = Base a utilizar para impresión
;   Salida:   Ninguno
;
; Descripción: imprime un número almacenado en AX
;              en la base dada por BX. Consta de 2
;              partes: 
;              - Sacar los dígitos a través de división con residuo
;              - Imprimir los residuos de las divisiones
; 
; Algoritmo para convertir número a base:
;
; do {
;   push numero % bx
;   numDigitos++
;   numero = numero / bx
; } while(numero > 0)
;
;////////////////////////////////////////////////////////////

extrn prntBase:near

;//////////////////////////////////////////////////////
; Procedimiento: gotoxy                            
;                                                  
; Parámetros: 
;   Entrada: DH = renglón (Eje Y)
;            DL = columna (Eje X)
;   Salida:  Ninguno
;                                                  
; Descripción: Establece el cursor en la posición  
;              dada por el registro DX. Se hace    
;              uso del servicio 2 de la            
;              interrupción 10h (llamadas al BIOS) 
;                                                  
;//////////////////////////////////////////////////////

extrn gotoxy:near

;//////////////////////////////////////////////////////
; Procedimiento: clrscr                            
;                                                  
; Parámetros:
;   Entrada: ninguno
;   Salida: ninguno                              
;                                                  
; Descripción: limpia la pantalla haciendo uso de  
;              la interrupción 10h, servicio 0.    
;              Se establece el modo de video       
;                                                  
;//////////////////////////////////////////////////////

extrn clrscr:near

;//////////////////////////////////////////////////////
; Procedimiento: getNum                            
;                                                  
; Parámetros:                                      
;   Entrada: Apuntador a la cadena guardado en DX  
;   Salida: Apuntador a la cadena guardado en DX   
;                                                  
; Descripción: lee una cadena que consta solamente de
;              dígitos, los cuales son almacenados en
;              memoria usando como apuntador a DI, que
;              toma como valor de inicio un apuntador
;              a una cadena dado por DX. Esta rutina
;              termina la cadena en 0.
;                                                  
;//////////////////////////////////////////////////////

extrn getNum:near

;//////////////////////////////////////////////////////
; Procedimiento: getAlpha                            
;                                                  
; Parámetros:                                      
;   Entrada: Apuntador a la cadena guardado en DX  
;   Salida: Apuntador al inicio de la cadena 
;           guardado en DX   
;                                                  
; Descripción: lee una cadena que consta solamente de
;              caracteres alfanuméricos (A-Za-z0-9),
;              los cuales son almacenados en
;              memoria usando como apuntador a DI, que
;              toma como valor de inicio un apuntador
;              a una cadena dado por DX. Esta rutina
;              termina la cadena en 0.
;                                                  
;//////////////////////////////////////////////////////

extrn getAlpha:near

;//////////////////////////////////////////////////////
; Procedimiento: backspace                           
;                                                 
; Parámetros: ninguno                             
;                                                 
; Descripción: borra caracter de la pantalla      
;              imprimiendo un espacio seguido del 
;              caracter 8 (backspace)             
;                                                 
;//////////////////////////////////////////////////////

extrn backspace:near

;//////////////////////////////////////////////////////
; Procedimiento: bubbleSort                            
;                                                  
; Parámetros:                                      
;   Entrada: DX = Apuntador a la cadena a ordenar
;            CL = Longitud de la cadena  
;   Salida: DX = Apuntador a la cadena ordenada
;                                                  
; Descripción: Ordena la cadena dada por el apuntador
;              en DX utilizando el algoritmo de
;              ordenación Bubble Sort.
;                                                  
;//////////////////////////////////////////////////////

extrn bubbleSort:near

extrn prntLine:near

;//////////////////////////////////////////////////////
; Procedimiento: atoi                            
;                                                  
; Parámetros:                                      
;   Entrada: Apuntador a la cadena a convertir en BX  
;   Salida: Cadena convertida almacenada en AX
;                                                  
; Descripción: Convierte la cadena dada por BX a un
;              entero interpretando sus contenidos como
;              un número entero, los cuales son 
;              almacenados en el registro AX.
;                                                  
;//////////////////////////////////////////////////////

extrn atoi:near

extrn copiaMemoria:near

extrn prntNum:near

extrn putchar:near

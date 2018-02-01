
.MODEL small
    .STACK 100h
	

INCLUDE procs.inc

    LOCALS

.DATA

 cad dw 100 dup(?)
 conta dw 0
 conte dw 0
 conti dw 0
 conto dw 0
 contu dw 0
 contc dw 0
 msga db "Cantidad de a: " ,0
 msge db "Cantidad de e: ",0
 msgi db "Cantidad de i: ",0
 msgo db "Cantidad de o: ",0
 msgu db "Cantidad de u: ",0
 msgc db "Cantidad de consonantes: ",0
 pspdir dw ?  ;direccion de psp  ; ? vacio
 cadtam equ byte ptr es:[80h] ;empieza tamano de cadena
 caddatosempieza equ byte ptr es:[81h] ;empieza datos de la cadena
 
.CODE

principal PROC


			push ds
			mov ax,@data
			mov ds,ax 

      xor ax,ax
				
			pop pspdir ;recuperas la direccion para tumbar los datos de la consola4
			
			mov es,pspdir
			
			lea bx,caddatosempieza ;contador indice para las direcciones
			;bx cuantos caracter llevas
			inc bx
			call imprimirCad
				 
		
			
			mov ah,4ch
			int 21h

			endp

;imprimir ccarcter por caracter
imprimirCad PROC
			push bx
	imp:	
			mov dl,es:[bx] ;carac en dl para imprimir
			cmp dl,' '
			je argu
			call contVocal
			mov ah,02h
			int 21h		
			inc bx
			jmp imp
argu:  		
			inc bx
			mov dl,es:[bx]
			mov [di],dl;guardar la cadena de 1 o 2 
			cmp dl,'1'
			je vocal
			cmp dl,'2'
			je cons
			;call mostrarCons ;mostrar consonante
			jmp final 
		
vocal:		call mostrar
      jmp final
			;te muestra las vocales 		
			;te muestra las vocales 		
cons: call mostrarCons
final:		pop bx
			ret
			endp
			

			
contVocal   PROC
			push dx
			;minusculas
			or dx,20h 
			cmp dl,'a'
			jne ese
			inc conta
      jmp salv
ese:		cmp dl,'e'
			jne essi
			inc conte	
      jmp salv
essi:		cmp dl,'i'
			jne eso
			inc conti
      jmp salv
eso:		cmp dl,'o'
			jne esu
			inc conto
      jmp salv
esu:		cmp dl,'u'
			jne fin2
			inc contu
      jmp salv
      jmp salv
fin2:       inc contc	;SERA  CONSONANTE
salv: pop dx
			ret ;es consonante te vas al otro caracter te sales del proc
			endp
			
			
convertir  	PROC
			push ax     ; num
			push bx     ; base

			mov cx,0    ; Limpiamos CX. Esto nos sirve para iniciar nuestro contador de dígitos en 0 al entrar al procedimiento.

        ; Aquí inicia el procedimiento de separar los dígitos
sepr: 	 	mov dx,0    ; Limpiamos el residuo en cada jump
			div bx      ; Dividimos nuestro número (AX) entre nuestra base (BX)
			push dx     ; Guardamos el residuo en la pila
			inc cx      ; Incrementamos en 1 la cantidad de dígitos
			cmp ax,0    ; Revisamos si todavía hay algo que dividir
			jne sepr    ; Volvemos a dividir si AX no es 0
			
			

impr:  		pop dx      ; Sacamos el residuo de la pila
			cmp dx,9    ; Verificamos si el número que tenemos es menor a 10
			jbe num      ; Si lo es, tenemos un dígito al que solamente le sumamos 30h para tener su equivalente ASCII
			add dx,07h  ; Si es mayor a 9, tenemos una letra, le sumamos 7h para convertir nuestro número
num:    	add dx,30h  ; Le sumamos 30h (ó 48d) para convertir el dígito a su equivalente en ASCII
			mov ah,02h  ; Llamamos al servicio de impresión de caracter
			int 21h     ; Invocamos la interrupción 21h de DOS
			loop impr   ; Repetimos hasta que CX sea 0

			pop ax      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
			pop bx      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
			ret
endp
		;mostrar cuantas vocales
mostrar	 	PROC
			push ax   ;salto de linea
			mov dx,0ah
			call putchar
			pop ax
			mov dx, offset msga
			call puts
			mov ax,conta
			mov bx,10
			call convertir
			
			
			push ax   ;salto de linea
			mov dx,0ah
			call putchar
			pop ax
			mov dx, offset msge
			call puts
			mov ax,conte
			mov bx,10
			call convertir
			
			push ax   ;salto de linea
			mov dx,0ah
			call putchar
			pop ax
			mov dx, offset msgi
			call puts
			mov ax,conti
			mov bx,10
			call convertir
			
			push ax   ;salto de linea
			mov dx,0ah
			call putchar
			pop ax
			mov dx, offset msgo
			call puts
			mov ax,conto
			mov bx,10
			call convertir
			
			push ax   ;salto de linea
			mov dx,0ah
			call putchar
			pop ax
			mov dx, offset msgu
			call puts
			mov ax,contu
			mov bx,10
			call convertir
			ret
			endp
			
			
mostrarCons	PROC
			push ax   ;salto de linea
			mov dx,10
			call putchar
			pop ax
			mov dx, offset msgc
			call puts
			mov ax,contc
			mov bx,10
			call convertir	
			ret
			endp


putcharr	PROC
			push ax
			push dx
			mov ah,02h
			int 21h
		;	mov al,10
			
			mov dl,0dh ;retorno de carro
			int 21h 
			mov dl,0ah ;linea
			int 21h
			
			
			
			pop dx 
			pop ax
			ret
			endp
			
			
			
end			
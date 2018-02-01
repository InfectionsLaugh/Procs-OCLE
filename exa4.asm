;PROGRAMA QUE RECIBE ARGUMENTOS Y CUENTA CUANTOS MANDASTE 
.MODEL small
    .STACK 100h
	

INCLUDE procs.inc

    LOCALS

.DATA

 cad dw 100 dup(?)
 pspdir dw ?  ;direccion de psp  ; ? vacio
 caddatosempieza equ byte ptr es:[81h] ;empieza datos de la cadena
cadtam equ byte ptr es:[80h] ;empieza tamano de cadena
 
.CODE

principal PROC
			push ds
			mov ax,@data
			mov ds,ax
				
			pop pspdir ;recuperas la direccion para tumbar los datos de la consola4 POP ES
			
			mov es,pspdir
			
			lea bx,caddatosempieza ;contador indice para las direcciones
			;bx cuantos caracter llevas
			inc bx
			
			call imprimirCad

			mov ah,4ch
      mov al,0
			int 21h

			endp

;imprimir ccarcter por caracter
imprimirCad PROC
			push bx
		
	imp:	
			mov dx,es:[bx] ;carac en dl para imprimir
			cmp dl,0dh
			je fin
			mov ah,02h
			int 21h
			inc bx
			
			jmp imp
		
			
fin:  pop bx
			call cuantos
			ret
			endp
			

cuantos PROC	
		mov dl,cadtam
		sub dl,1
		add dl,30h
		mov ah,02h
		int 21h

	;	cmp dl,50d
		

		endp
		ret

putss 	PROC
			push dx
			mov dl,0dh ;retorno de carro
			int 21h 
			mov dl,0ah ;linea
			int 21h
			pop dx
			
			;mov dl,cl
			;add dl,30h		;conversion ascii le sumas el ascii 0 para el offset 
			
			mov ah,09h ;imprimir cadena 
			int 21h
			ret
			endp			

end
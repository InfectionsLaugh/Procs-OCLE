;PROGRAMA XOR
.MODEL small
    .STACK 100h
	

INCLUDE procs.inc

    LOCALS

.DATA

 cad dw 100 dup(?)
 pspdir dw ?  ;direccion de psp  ; ? vacio
 caddatosempieza equ byte ptr es:[81h] ;empieza datos de la cadena
cadtam equ byte ptr es:[80h] ;empieza tamano de cadena
temp db 100 dup(?)
clav db 100 dup(?)
 
.CODE

principal PROC
			push ds
			mov ax,@data
			mov ds,ax
				
			pop es ;recuperas la direccion para tumbar los datos de la consola4 POP ES
	
			inc bx
			lea di,temp
			lea si,clav

			
			call contarmensaje
			
			call guardarclave
			
			
			
			lea di,temp
			lea si,clav
			call hacerxor
			lea dx,temp
			call puts
			
			
			
			mov ah,4ch
			;mov al,0 ;para indicarle que termino bien 
			int 21h

			endp

;imprimir ccarcter por caracter
imprimirCad PROC
			
			mov bx,82h
			
			push di

			
	imp:	;cadena principal de 50 o menos 
			mov dl,es:[bx] ;carac en dl para imprimir
			cmp dl,' '
			je fin
			mov [di],dl
			;mov ah,02h
			;int 21h
			inc bx
			inc di
			jmp imp
		
	fin: 	mov dl,0
			mov [di],dl
			pop di
			
			ret
			endp
			
			
contarmensaje	PROC
				mov cx,0
				mov al,0
				mov bx,82h
				
	seguir:		mov dl,es:[bx]
				cmp dl,' '
				je esclaveban
				cmp al,1 ;empieza clave
				jae esclave
				
				cmp ch,50d
				ja finconerror
				inc ch ; cont mensaje 
				inc bx
				
				jmp seguir
			
	esclaveban: mov al,1 ;bandera
				inc bx
				jmp seguir
				
	esclave:	inc bx
				cmp dl,0dh
				je fin2
				inc cl; cont clave
				cmp cl,8d
				ja finconerror
			
				jmp seguir

				
finconerror:	mov ah,4ch
				mov al,1
				int 21h
		fin2:		
				ret
				endp
			
guardarclave	PROC
				inc bx
				
				push si
				
	seguirle:	 
				mov dl,es:[bx]
				cmp dl,0dh
				je fin3
				mov [si],dl
				inc bx
				inc si
				jmp seguirle
				
	
	fin3:		mov dl,0
				mov [si],dl
			
				pop si
				ret	
				endp

hacerxor	PROC	
			push di
			push si
			
	pila:	push si;direccion final 
			
			
seeeguir:	mov al,[di]
			cmp al,0
			
			je fin4
			mov ah,[si]
			
			cmp ah,0
			je quitar
			
			
			xor [di],ah
			inc di
			inc si
			
			jmp seeeguir

quitar: 	pop si
			jmp pila
			
fin4:		
			pop si
			pop di
			ret
			endp		

end
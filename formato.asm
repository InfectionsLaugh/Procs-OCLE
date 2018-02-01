MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

 INCLUDE procs.inc
 
       LOCALS

   .DATA
      mens       db  'Hola Mundo',0

   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr

				mov ax,9377
				call esAutomorfico
				mov dl,ah
				add dl,30h
				mov ah,02h
				int 21h

				call getch

				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ; 

                ENDP

; incluir procedimientos	
; ejemplo:
; funcionX PROC ; < -- Indica a TASM el inicio del un procedimiento
;               ; 
;               ; < --- contenido del procedimiento
;           ret
;           ENDP; < -- Indica a TASM el fin del procedimiento

esAutomorfico PROC
				push bx
				push cx
				push dx
				
				; cx = 1
				; do {
				; 	ax /= 10
				; 	cx *= 10
				; } while(ax != 0)
				push ax
				xor cx,cx
				mov cx,1
sdig: 			mov dx,0
				mov bx,10
				div bx
				push ax
				mov ax,cx
				mul bx
				mov cx,ax
				pop ax
				cmp ax,0
				jne sdig
				
				pop ax
				push ax
				mul ax
				div cx
				pop ax
				cmp dx,ax
				jne noes
				mov ah,1
				jmp fin
				
noes:			mov ah,0
fin:			pop dx
				pop cx
				pop bx
				ret
ENDP

         END

MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

 INCLUDE procs.inc
 
       LOCALS

   .DATA
      mens       db  'Yeah',0
      yeah       db  'Hola',0

   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

        mov ax,10
        cmp ax,10
        jne end
        mov ax,1

        end:
          inc ax

				call getch

				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ; 
    ENDP

    Imprime PROC
        mov ax,@data
        mov ds,ax

        mov dx,offset yeah
        call puts

        call getch

        mov ah,04ch
        mov al,0

        ret
    ENDP

; incluir procedimientos	
; ejemplo:
; funcionX PROC ; < -- Indica a TASM el inicio del un procedimiento
;               ; 
;               ; < --- contenido del procedimiento
;           ret
;           ENDP; < -- Indica a TASM el fin del procedimiento



         END

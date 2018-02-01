.MODEL small
.STACK 100h

include milib.inc

.DATA
  mens_21   db    "Desplegado de cadena con INT 21h: ",0
  mens_10   db    13,10,"Desplegado de cadena con INT 10h: ",0
  mens_vm   db    13,10,"Desplegado de cadena con x y y: ",0
  mes       db    "Cadena",0
  mes2      db    "Cadena$"

.CODE
        mov ax,@data
        mov ds,ax
        mov es,ax

        call clrscr

        lea dx,mens_21
        call puts
        lea dx,mes2
        mov ah,09h
        int 21h

        lea dx,mens_10
        call puts
        mov ah,13h
        mov al,0
        mov bh,0
        mov bl,0ffh
        mov cx,6
        mov dh,1
        mov dl,34
        lea bp,mes
        int 10h

        lea dx,mens_vm
        call puts

        mov bx,1315
        lea dx,mes
        call putsxy
        
        mov ah,4ch
        mov al,0
        int 21h

putsxy PROC near
        push ax
        push bx
        push cx
        push dx

        push dx
        mov dx,bx
        mov bx,0
        call gotoxy

        pop dx
        call puts

        pop dx
        pop cx
        pop bx
        pop ax
        ret
ENDP
END
.MODEL small
.STACK 100h

include milib.inc

.DATA
  msg   db  "Direccion sin normalizar: ",0
  msg2  db  "Direccion normalizada: ",0
.CODE
        mov ax,@data
        mov ds,ax

        mov dx,1236h
        mov ax,3450h

        push ax
        and ax,0fff0h
        mov cl,4
        shr ax,cl
        add dx,ax
        pop ax
        and ax,0fh
        push ax
        mov ax,dx
        mov bx,10h
        call prntBase
        pop ax
        push dx
        mov dl,':'
        call putchar
        pop dx
        mov bx,10h
        call prntBase

fin:    mov ah,4ch
        mov al,0
        int 21h
END
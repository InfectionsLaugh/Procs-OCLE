.MODEL small
.STACK 100h

include milib.inc

.DATA
  mens_directo  db  "Desplegado de caracter de forma directa: ",0
  mens_dos      db  13,10,"Desplegado de caracter con DOS: ",0
  mens_bios     db  13,10,"Desplegado de caracter con BIOS: ",0
  new           db  13,10,0

.CODE
        mov ax,@data
        mov ds,ax
        call clrscr

        lea dx,mens_directo
        call puts
        mov al,'x'
        mov bh,41
        mov bl,0
        call putcharxy

        lea dx,mens_dos
        call puts
        mov dl,'x'
        mov ah,02h
        int 21h

        lea dx,mens_bios
        call puts
        mov al,'x'
        mov ah,0ah
        mov bx,0
        mov cx,1
        int 10h

        mov ah,4ch
        mov al,0
        int 21h
putcharxy PROC near
        push ax
        push bx
        push cx
        push dx
        push ds

        mov dx,ax

        mov ax,0b800h
        mov ds,ax

        mov cl,160
        mov al,bl
        mul cl
        mov bl,bh
        mov bh,0
        shl bx,1
        add bx,ax

        mov [bx],dl

        pop ds
        pop dx
        pop cx
        pop bx
        pop ax
        ret
ENDP
END
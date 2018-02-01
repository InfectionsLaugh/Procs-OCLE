.MODEL small
.STACK 100h

include milib.inc

.DATA
  pri   db    "Es Primo",0
  npr   db    "No Es Primo",0

.CODE
        mov ax,@data
        mov ds,ax

        mov bx,7
        call esPrimo

        mov dl,ah
        add dl,30h
        mov ah,02h
        int 21h

        mov ah,4ch
        mov al,0
        int 21h

esPrimo PROC near
        push bx
        push cx
        push dx

        mov cx,2

        mov dx,0

sep:    mov dx,0
        cmp cx,bx
        jg fprm
        mov ax,bx
        div cx
        cmp dx,0
        je fprm
        inc cx
        jmp sep

fprm:   mov ah,dl
        pop dx
        pop cx
        pop bx
        ret
ENDP
END
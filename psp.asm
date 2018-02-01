.MODEL small
.STACK 100h

include milib.inc

.DATA
  cad   db  "Cadena desde consola: ",0
  str1  db  0
  str2  db  0
.CODE
        push ds
        mov ax,@data
        mov ds,ax
        pop es

        mov bx,82h
        lea di,str1
        lea si,str2

        xor ax,ax

impr:   mov dl,[es:bx]
        cmp dl,0dh
        je fin
        cmp dl,':'
        je delim
        cmp ax,1
        je secad
        mov [di],dl
        inc di
        jmp sigue
delim:  inc ax
        jmp sigue
secad:  mov [si],dl
        inc si
        jmp sigue
sigue:  mov ah,02h
        int 21h
        inc bx
        jmp impr

fin:    mov dl,0
        mov [di+1],dl
        mov [si+1],dl
        lea dx,str1
        call puts
        lea dx,str2
        call puts
        mov ah,4ch
        mov al,0
        int 21h
END
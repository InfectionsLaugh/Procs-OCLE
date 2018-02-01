.MODEL small
.STACK 100h

include milib.inc

.DATA
  cad   db  "Cadena a verificar: ",0
  mac   db  "fe:90:12:32:0d:ab",0
.CODE
        mov ax,@data
        mov ds,ax

        mov di,dx
        xor ah,ah
        inc ah
        xor cx,cx

smac:   mov dl,[di]
        cmp dl,0
        je fins
        cmp dl,':'
        je val
nums:   cmp dl,'0'
        jb mayu
        cmp dl,'9'
        ja mayu
        jmp val
mayu:   cmp dl,'A'
        jb minu
        cmp dl,'F'
        ja minu
        jmp val
minu:   cmp dl,'a'
        jb fin
        cmp dl,'f'
        ja fin
val:    cmp cx,2
        jne nxt
        cmp dl,':'
        jne fin
        xor cx,cx
        inc di
        jmp smac
nxt:    inc cx
        inc di
        jmp smac

fin:    xor ah,ah
fins:   mov dl,ah
        add dl,30h
        mov ah,02h
        int 21h
        mov ah,04ch
        mov al,0
        int 21h
END
.MODEL small
.STACK 100h

.CODE
        xor ax,ax
        mov cl,4
        mov ah,01h
        int 21h
        cmp al,'9'
        jbe num
        sub al,07h
num:    sub al,30h
        shl al,cl
        mov bl,al
        int 21h
        cmp al,'9'
        jbe enum
        sub al,07h
enum:   sub al,30h
        add bl,al
        xchg bl,al

        mov ah,4ch
        mov al,0
        int 21h
END
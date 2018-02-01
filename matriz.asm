.MODEL small
    .STACK 100h

    LOCALS

    .DATA
        clen    equ     byte ptr es:[80h]
        cdat    equ     byte ptr es:[81h]
        arra    dw      100 dup(?)
        PSP     dw      ?
        men     db      "Hay uno o mas delimitadores en la cadena$"
    .CODE
        push ds
        mov ax,@data
        mov ds,ax

        pop PSP

        mov es,PSP

        lea bx,cdat
        inc bx

        call imprCmd

        mov ah,4ch
        int 21h

imprCmd proc near
        push bx

impr:   mov dx,es:[bx]
        cmp dx,0Dh
        jz fin
        mov ah,02h
        int 21h
        inc bx
        jmp impr

fin:    pop bx
        ret
endp

esDelim proc near
        cmp dx,' '
        jz siEs
        cmp dx,','
        jz siEs
        cmp dx,0Ah
        jz siEs
        cmp dx,';'
        jz siEs
        cmp dx,'='
        jz siEs
        cmp dx,0Dh
        jz siEs

siEs:   ret
endp

END 
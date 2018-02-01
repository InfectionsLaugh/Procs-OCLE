.MODEL small
.STACK 100h

print macro men
    lea dx,men
    call puts
endm

include milib.inc

.DATA
  mens    db  50 dup(?)
  cado    db  "Cadena completa: ",0
  cmen    db  13,10,"Mensaje: ",0
  ckey    db  13,10,"Llave: ",0
  cmod    db  13,10,"Mensaje cifrado: ",0
  merr    db  "Error. El mensaje debe tener maximo 50 caracteres.",0
  mekey   db  "Error. La clave debe tener maximo 8 caracteres.",0
  mequ    db  "Error. La clave no puede ser mas larga que el mensaje original.",0
  llave   db  8 dup(?)

.CODE
        push ds
        mov ax,@data
        mov ds,ax
        pop es

        call clrscr

        mov bx,82h
        call cuentaParams

        print cado

        lea di,mens
        lea si,llave
        call guardaClaves

        print cmen
        print mens
        print ckey
        print llave
        print cmod

        lea di,mens
        lea si,llave
        call cifrar

finp:   lea dx,mens
        call exit

cifrar PROC near
        push di
        push si

mete:   push si

cifra:  mov dh,[di]
        cmp dh,0
        je finp
        mov dl,[si]
        cmp dl,0
        je repkey
        xor dh,dl
        mov [di],dh
        inc di
        inc si
        jmp cifra

repkey: pop si
        jmp mete

finc:   pop si
        pop di
        ret
ENDP

cuentaParams PROC near
        push bx
        push dx

        xor cx,cx
        xor dx,dx
        
cuenta: mov dl,es:[bx]
        cmp ch,50
        ja errmen
        cmp dh,0
        ja cpkey
        cmp dl,' '
        je cpdel
        inc ch
        jmp scnt
cpkey:  cmp dl,0dh
        je fcp
        cmp cl,8
        je errmnk
        inc cl
cpdel:  inc dh
scnt:   inc bx
        jmp cuenta

errmnk: lea dx,mekey
        jmp salir
errequ: lea dx,mequ
        jmp salir
errmen: lea dx,merr
salir:  call exit
fcp:    cmp cl,ch
        ja errequ
        pop dx
        pop bx
        ret
ENDP

exit PROC near
        call puts
        mov ah,4ch
        mov al,0
        int 21h
ENDP

guardaClaves PROC near
        push di
        push si

        xor cx,cx

pcp:    mov dl,es:[bx]
        cmp dl,0dh
        je fin
        mov ah,02h
        int 21h
        cmp ch,0
        ja clave
        cmp dl,' '
        je delim
        mov [di],dl
        inc di
        jmp stahp
clave:  mov [si],dl
        inc si
delim:  inc ch
stahp:  inc bx
        inc cl
        jmp pcp

fin:    xor ax,ax
        mov [si],ax
        mov [di],ax

        pop si
        pop di
        ret
ENDP
END
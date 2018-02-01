.MODEL small
.STACK 100h

.DATA

.CODE

; 0110 1000 (68) -> 1110 1000 (E8)

mov cl,1000b
ror cl,1b
add cl,00110000b

mov ah,02h
mov dl,cl
int 21h

mov ah,04ch
mov al,0
int 21h

setBit PROC
      push cx

      cmp cl,1
      jb cer
      

cer:  add cl,1 
      jmp sor

sor:  or al,cl

      pop cx
      ret 
ENDP

clearBit PROC
    push cx

    and al,cl

    pop cx
    ret
ENDP

notBit PROC
    push cx

    xor al,cl

    pop cx
    ret
ENDP

END
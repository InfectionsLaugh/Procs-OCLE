print macro m
  mov ah,09h
  mov dx,offset m
  int 21h
endm

.MODEL small
  .STACK 100h

  LOCALS

  .DATA
    iMessage    db    "Ingresa un numero: $"
    oMessage    db    "Lo que ingresaste fue: $"
    bMessage    db    "Base a convertir: $"
    num1        db    ?

  .CODE
    mov ax,@data
    mov ds,ax

    print iMessage

    mov ah,01
    int 21h

    call readFirstDigit

    mov ah,01
    int 21h
    sub al,30h
    cmp al,09
    jbe num2
    sub al,07

num2: or bl,al
    mov num1,bl
    mov bl,num1

    call printNewLine

    print oMessage

    call displayNum

    mov ah,4ch
    mov al,0
    int 21h

readNumber proc
  sub al,30h

  cmp al,09
  jbe num
  sub al,07

num: mov cl,04
  rol al,cl
  mov bl,al
endp

printNewLine proc near
  mov ah,06h
  mov dl,0Ah
  int 21h

  mov ah,06h
  mov dl,0Dh
  int 21h
endp

displayNum proc near
  mov al,bl
  mov cl,04
  and al,0f0h
  shr al,cl
  cmp al,09
  jbe number
  add al,07

number: add al,30h
  mov dl,al
  mov ah,02
  int 21h

  mov al,bl
  and al,00fh
  cmp al,09
  jbe number2
  add al,07
number2: add al,30h
  mov dl, al
  mov ah,02
  int 21h
  ret
ENDP
END
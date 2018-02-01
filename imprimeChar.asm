.MODEL small
  .STACK 100h

  LOCALS

  .DATA
    iMessage    db    "Ingresa un numero: $"
    oMessage    db    "Lo que ingresaste fue: $"
    num         db    0

  .CODE
    mov ax,@data
    mov ds,ax

    mov ah,09h
    mov dx,offset iMessage
    int 21h

    mov ah,4ch
    mov al,0
    int 21h

  END
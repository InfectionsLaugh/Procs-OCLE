.MODEL small
.STACK 100h

INCLUDE milib.inc

LOCALS

.DATA
  mens  db  "Hola",0

.CODE
      mov ax,@data
      mov ds,ax

      lea dx,mens
      call puts

      call strlen

      mov dx,cx
      add dx,30h

      mov ah,02h
      int 21h

      mov ah,4ch
      mov al,0
      int 21h
END

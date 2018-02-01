.MODEL small
.STACK 100h

.DATA
  msg   db  "Hola$"
  msg2  db  "NoHola$"

.CODE
      mov ax,@data
      mov ds,ax

      mov ax,1234h
      mov bx,3412h

      add ax,bx
      jns lbl1

      lea dx,msg2
      mov ah,09h
      int 21h

lbl1: lea dx,msg
      mov ah,09h
      int 21h

      mov ah,4ch
      mov al,0
      int 21h
END
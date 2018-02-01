.MODEL small
.STACK 100h

.CODE
      mov ax,1234h
      mov bx,3121h
      mov cx,ax
      mov dx,bx
      not cx
      not dx
      and ax,dx
      not ax
      and bx,cx
      not bx
      and ax,bx
      not ax

      mov ah,4ch
      mov al,0
      int 21h
END
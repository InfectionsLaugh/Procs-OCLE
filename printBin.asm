.MODEL small
.STACK 100h

include milib.inc

.DATA

.CODE
      mov ax,1a64h
      mov dx,1234h

      push ax
      mov ax,dx
      call printBinGuiones
      mov dl,'-'
      mov ah,02h
      int 21h
      pop ax
      call printBinGuiones

      mov ah,4ch
      int 21h

printBinGuiones PROC
      push ax
      push bx
      push cx
      push dx

      mov cl,16
      xor ch,ch
      mov bx,ax

next: mov ax,'0'
      shl bx,1
      adc ax,0
      mov dx,ax
      call putchar
      inc ch
      cmp ch,4
      jb sigu
      cmp cl,1
      je sigu
      mov dx,'-'
      call putchar
      xor ch,ch
sigu: dec cl
      jnz next

      pop dx
      pop cx
      pop bx
      pop ax
      ret
ENDP
END
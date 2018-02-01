.MODEL small
.STACK 100h

include milib.inc

.DATA
  msg   db    "Total: ",0

.CODE
      push ds
      mov ax,@data
      mov ds,ax
      pop es

      call clrscr

      mov bx,82h

      xor cx,cx

imp:  mov dl,es:[bx]
      cmp dl,0dh
      je fn
      mov ah,02h
      int 21h
      cmp dl,' '
      jne sigue
      mov dl,0dh
      int 21h
      mov dl,0ah
      int 21h
      inc cx
sigue:inc bx
      jmp imp

fn:   inc cx
      mov dl,0dh
      int 21h
      mov dl,0ah
      int 21h
      lea dx,msg
      call puts
      mov dl,cl
      add dl,30h
      mov ah,02h
      int 21h
      mov ah,04ch
      mov al,0
      int 21h
END
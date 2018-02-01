.MODEL small
.STACK 100h

include milib.inc

.DATA
  cad   db  127 dup(?)
  msg   db  "Cadena original: ",0
  msg2  db  "Cadena ordenada: ",0
.CODE
      push ds
      mov ax,@data
      mov ds,ax
      pop es

      xor cx,cx

      lea dx,msg
      call puts

      mov bx,82h

      lea di,cad
      push di
nxtc: mov dl,es:[bx]
      cmp dl,0dh
      je sort
      mov ah,02h
      int 21h
      mov [di],dl
      inc di
      inc bx
      jmp nxtc

sort: mov dl,0
      mov [di],dl
      pop di

      mov cl,es:[80h]
      lea dx,cad
      call bubbleSort

fin:  lea dx,msg2
      call prntLine
      call puts
      lea dx,cad
      call puts

      mov ah,4ch
      mov al,0
      int 21h
END
.MODEL small
.STACK 100h

.DATA
  cad   db  "the quick brwn f jumps ver the lazy dg",0

.CODE
          mov ax,@data
          mov ds,ax

          lea dx,cad
          call espangrama

          mov dl,ah
          add dl,30h
          mov ah,02h
          int 21h

          mov ah,4ch
          mov al,0
          int 21h

espangrama PROC near
          push dx

          mov bx,dx
          mov ax,0
          mov cl,0

sigue:    mov dl,[bx]
          cmp dl,0
          je fin
          cmp dl,'a'
          jb nxt
          cmp dl,'z'
          ja nxt
          inc al
          inc cl
nxt:      inc bx
          jmp sigue

fin:      cmp cl,26
          jbe pops
          mov ah,1
pops:     pop dx
          ret
ENDP

END
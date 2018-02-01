.MODEL small
.STACK 100h

include milib.inc

.DATA
  cad   db  "alumna",0
.CODE
        mov ax,@data
        mov ds,ax

        lea dx,cad
        call esIsograma

        mov dl,ah
        add dl,30h
        mov ah,02h
        int 21h

        mov ah,4ch
        mov al,0
        int 21h

esIsograma PROC near
          push bx
          push cx
          push dx

          call strlen
          mov di,dx

          mov ah,0

sigue:    mov dl,[di]
          mov bx,di
          inc bx
sfor:     mov dh,[bx]
          cmp dh,0
          je slfor
          cmp dl,dh
          jz fin
          inc bx
          jmp sfor
slfor:    inc di
          loop sigue

          mov ah,1
fin:      pop dx
          pop cx
          pop bx
          ret
esIsograma ENDP
END

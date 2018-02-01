.MODEL small
.STACK 100h

include milib.inc

.DATA
  lim   dw   500
  cad   db   "Resultado: ",0
.CODE
        mov ax,@data
        mov ds,ax

        call clrscr

        call mul35

        lea dx,cad
        call puts

emain:  mov bx,10
        call prntBase

        mov ah,4ch
        mov al,0
        int 21h

mul35 PROC near
        push bx
        push cx
        push dx

        mov ax,0
        mov bx,1
        mov cx,0
        mov dx,0

cont:   mov dx,0
        cmp bx,lim
        jae fin
        mov ax,bx
        push bx
        mov bx,3
        div bx
        pop bx
        cmp dx,0
        je suma
        mov ax,bx
        mov dx,0
        push bx
        mov bx,5
        div bx
        pop bx
        cmp dx,0
        jne nxt
suma:   add cx,bx
nxt:    inc bx
        jmp cont

fin:    mov ax,cx

        pop dx
        pop cx
        pop bx
        ret
ENDP
END
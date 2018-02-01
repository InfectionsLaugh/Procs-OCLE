.MODEL small
.STACK 100h

include milib.inc

.DATA
  lim   dw   65535
  cad   db   "# de fibonacci: ",0
.CODE
        mov ax,@data
        mov ds,ax

        call clrscr

        lea dx,cad
        call puts

        mov ax,0
        mov bx,0
        mov cx,1
        mov dx,0

sfib:   cmp dx,20
        ja ffib
        cmp dx,1
        ja sufib
        mov ax,dx
        jmp nfib
sufib:  push cx
        add bx,cx
        mov ax,bx
        pop bx
        mov cx,ax 
nfib:   call prntNum
        inc dx
        jmp sfib

ffib:   mov ah,4ch
        mov al,0
        int 21h

prntNum  PROC near
        push ax
        push bx
        push dx

        mov bx,10
        mov dl,' '
        call prntBase
        mov ah,02h
        int 21h

        pop dx
        pop bx
        pop ax
        ret
ENDP
END
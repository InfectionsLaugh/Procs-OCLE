.MODEL small
.STACK 100h

LOCALS

include milib.inc

.DATA
  mc1   db    "Cadena a guardar en AX: ",0
  mc2   db    "Dato guardado en AX: ",0
  cad   db    0
  new   db    13,10,0

.CODE
        mov ax,@data
        mov ds,ax

        call clrscr

        lea dx,mc1
        call puts

        lea dx,cad
        call getNum
        
        lea bx,cad
        call atoi

        lea dx,mc2
        call puts
        mov bx,10h
        call prntBase

        mov ah,04ch
        mov al,0
        int 21h

atoi PROC near
        push bx
        push cx
        push dx

        mov ax,0
        mov cx,0Ah

conv:   mov dh,0
        mov dl,[bx]
        cmp dl,0
        je fatoi
        cmp dl,'0'
        jb ignra
        cmp dl,'9'
        ja ignra
        push dx
        mul cx
        pop dx
        sub dx,30h
        add ax,dx
ignra:  inc bx
        jmp conv

fatoi:  pop dx
        pop cx
        pop bx
        ret
ENDP
END
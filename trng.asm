.MODEL small
.STACK 100h

include milib.inc

LOCALS

.DATA
  num   db  4 dup (?)
  errr  db  "Error: Numero fuera del rango permitido",0
.CODE
        push ds
        mov ax,@data
        mov ds,ax
        pop es

        call clrscr

        mov bx,82h
        xor dx,dx
        xor cx,cx
        lea di,num

psp:    mov dl,[es:bx]
        cmp dl,0dh
        je fpsp
        mov [di],dl
        inc bx
        inc di
        jmp psp

fpsp:   xor dl,dl
        mov [di],dl
        lea bx,num
        call atoi
        cmp ax,255
        ja error
        cmp ax,0
        jbe error

        call triangular

error:  lea dx,errr
        call puts
fprgrm: mov ah,4ch
        mov al,0
        int 21h

triangular  PROC near
        push ax
        push bx
        push cx
        push dx

        mov dx,ax

trng:   push dx
        push cx
        inc cx
        pop ax
        mul cx
        mov bx,2
        div bx
        mov bx,10
        call prntBase
        call prntLine
        pop dx
        cmp cx,dx
        jz fprgrm
        jmp trng

        pop dx
        pop cx
        pop bx
        pop ax
        ret
ENDP

prntLine PROC near
        push ax
        push dx

        mov ah,02h
        mov dl,0dh
        int 21h

        mov dl,0Ah
        int 21h

        pop dx
        pop ax
        ret
prntLine ENDP
  
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
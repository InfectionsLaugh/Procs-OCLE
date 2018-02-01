.MODEL small
.STACK 100h

LOCALS

.DATA
  menAscii  db  "AL desplegado en ASCII: ",0
  menBin    db  "AL desplegado en Binario: ",0
  menDec    db  "AL desplegado en Decimal: ",0
  menHex    db  "AL desplegado en Hexadecimal: ",0
  crlf      db  13,10,0

.CODE
  mov ax,@data
  mov ds,ax
  call clrscr

  mov al,59h
  lea dx,menAscii
  call puts
  call putchar

  lea dx,crlf
  call puts

  lea dx,menBin
  call puts
  call printBin

  lea dx,crlf
  call puts  

  lea dx,menDec
  call puts
  call printDec

  lea dx,crlf
  call puts

  lea dx,menHex
  call puts
  call printHex

  lea dx,crlf
  call puts

  mov ah,04ch
  mov al,0
  int 21h

; ------------ PROCEDIMIENTOS ------------

printBin PROC
        push ax
        push cx

        mov cx,8
        mov ah,al

next:   mov al,'0'
        shl ah,1
        adc al,0
        call putchar
        loop next

        pop cx
        pop ax
        ret        
ENDP

printDec PROC
        push ax
        push bx
        push cx
        push dx

        mov cx,3
        mov bx,100
        mov ah,0

nxtD:   mov dx,0
        div bx
        add al,'0'
        call putchar
        mov ax,dx
        push ax
        mov dx,0
        mov ax,bx
        mov bx,10
        div bx
        mov bx,ax
        pop ax
        loop nxtD

        pop dx
        pop cx
        pop bx
        pop ax
        ret
ENDP

printHex PROC
        push ax
        push bx
        push cx

        mov ah,0
        mov bl,16

        div bl
        mov cx,2

nxtH:   cmp al,10
        jb imph
        add al,7
imph:   add al,30h
        call putchar
        mov al,ah
        loop nxtH

        pop cx
        pop bx
        pop ax
        ret
ENDP

clrscr PROC
        push ax

        mov ah,0
        mov al,3
        int 10h

        pop ax
        ret
ENDP

putchar PROC
        push ax
        push dx

        mov dl,al

        cmp dl,'0'
        jae prnt
        cmp dl,9
        jbe num
        add dl,07h
num:    add dl,30h
prnt:   mov ah,02h
        int 21h

        pop dx
        pop ax
        ret
ENDP

puts PROC
        push dx
        push ax

        mov di,dx

impr:   mov dl,[di]
        cmp dl,0
        je fin
        mov ah,02h
        int 21h
        inc di
        jmp impr

fin:    pop ax
        pop dx
        ret
ENDP

END
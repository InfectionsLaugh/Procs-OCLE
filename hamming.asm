.MODEL small
.STACK 100h

include milib.inc

.DATA
  msg   db  "Numero ingresado: ",0
  bin   db  "En binario: ",0
  merr  db  "Modo de uso: hamming [numero hexadecimal]",0
  cad   db  127 dup(?)
  dsh   db  0
.CODE
        push ds
        mov ax,@data
        mov ds,ax
        pop es

        mov bx,82h
        lea di,cad
        rep 

    spar:   
        mov dl,es:[bx]
        cmp dl,0dh
        je fipar
        cmp dl,'0'
        jb letra
        cmp dl,'9'
        ja letra
        jmp gpar
    letra:  
        cmp dl,'A'
        jb min
        cmp dl,'F'
        ja min
        jmp gpar
min:    cmp dl,'a'
        jb error
        cmp dl,'f'
        ja error
gpar:   mov [di],dl
        inc bx
        inc di
        jmp spar

error:  lea dx,merr
        call puts
        jmp emain
fipar:  mov dl,0
        mov [di],dl
        lea bx,cad
        call atoi
        mov bx,2
        call printHamming

emain:  mov ah,4ch
        mov al,0
        int 21h

atoi PROC near
        push bx
        push cx
        push dx

        mov ax,0
        mov cx,10h

conv:   mov dh,0
        mov dl,[bx] 
        cmp dl,0 
        je fatoi 
        cmp dl,'0' 
        jb hexa 
        cmp dl,'9'
        ja hexa
        jmp convi
hexa:   cmp dl,'A'
        jb hexmin
        cmp dl,'F'
        ja hexmin
        jmp convi
hexmin: cmp dl,'a'
        jb ignra
        cmp dl,'f'
        ja ignra
        xor dl,20h
convi:  push dx
        mul cx
        pop dx
        cmp dl,'9'
        jb esnum
        sub dx,07h
esnum:  sub dx,30h
        add ax,dx
ignra:  inc bx
        jmp conv

fatoi:  pop dx
        pop cx
        pop bx
        ret
ENDP

printHamming PROC near
        push ax     ; Metemos el número a convertir a la pila. Esto es conveniente pues vamos a modificar ax más adelante.
        push bx     ; Metemos la base a la que queremos convertir a la pila. Esto es conveniente pues vamos a modificar bx más adelante.
        push cx
        push dx

        mov dx,0    ; Limpiamos DX. Esto nos sirve para siempre tener el residuo en 0 al entrar al procedimiento.
        mov cx,0    ; Limpiamos CX. Esto nos sirve para iniciar nuestro contador de dígitos en 0 al entrar al procedimiento.

        ; Aquí inicia el procedimiento de separar los dígitos
sepa:   mov dx,0    ; Limpiamos el residuo en cada jump
        div bx      ; Dividimos nuestro número (AX) entre nuestra base (BX)
        push dx     ; Guardamos el residuo en la pila
        cmp dx,0
        jnz idsh
        inc dsh
        jmp nsepa
idsh:   push ax
        xor ax,ax
        mov al,dsh
        push bx
        mov bx,10
        call prntBase
        pop bx
        mov dl,' '
        mov ah,02h
        int 21h
        pop ax
        mov dsh,0
nsepa:  inc cx      ; Incrementamos en 1 la cantidad de dígitos
        cmp ax,0    ; Revisamos si todavía hay algo que dividir
        jne sepa    ; Volvemos a dividir si AX no es 0

        mov dl,0dh
        mov ah,02h
        int 21h
        mov dl,0ah
        int 21h

prnt:   pop dx      ; Sacamos el residuo de la pila
        cmp dx,9    ; Verificamos si el número que tenemos es menor a 10
        jbe num     ; Si lo es, tenemos un dígito al que solamente le sumamos 30h para tener su equivalente ASCII
        add dx,07h  ; Si es mayor a 9, tenemos una letra, le sumamos 7h para convertir nuestro número
num:    add dx,30h  ; Le sumamos 30h (ó 48d) para convertir el dígito a su equivalente en ASCII
        mov ah,02h  ; Llamamos al servicio de impresión de caracter
        int 21h     ; Invocamos la interrupción 21h de DOS
        loop prnt   ; Repetimos hasta que CX sea 0

        pop dx      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
        pop cx      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
        pop bx
        pop ax
        ret
ENDP
END
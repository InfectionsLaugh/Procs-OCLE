printLine macro
    mov ah,02h
    mov dl,0Dh
    int 21h

    mov dl,0Ah
    int 21h
endm

.MODEL small
.STACK 100h

LOCALS

.DATA
    tamBuf  db      "Ingresa numero en hex: $"
    string  db      100 dup(?)

.CODE
        mov ax,@data
        mov ds,ax

        lea dx,tamBuf
        mov ah,09h
        int 21h

        lea si,string
        mov cx,0

        call leeNumero

        printLine

        call imprNume
        call atoi

        printLine
        
        mov bx,16
        call printNumBaseX
        
        mov ah,4ch
        mov al,0
        int 21h

atoi proc near
        push si

        mov al,0
        mov bx,16

mvch:   mov dl,[si]
        cmp dl,'$'
        je fai
        mul bh
        add dl,30h
        add al,dl
        inc si
        jmp mvch

fai:    pop si
        ret
endp

imprNume proc near
        push si
        push cx

print:  mov dl,[si]
        cmp dl,'$'
        je fpr
prn:    mov ah,02h
        int 21h
        inc si
        jmp print

fpr:    pop si
        pop cx
        ret
endp

leeNumero proc near
        push si
        push dx

lee:    cmp cx,10
        je final
        mov ah,08h
        int 21h
        cmp al,0Dh
        je final
        cmp al,'0'
        jb lsig
        cmp al,'9'
        jg lsig
guarda: mov dl,al
        mov ah,02h
        int 21h
        mov [si],dl
        inc si
        inc cx
lsig:   jmp lee

final:  mov dl,'$'
        mov [si],dl
        pop dx
        pop si
        ret
endp

printNumBaseX proc
        push ax     ; Metemos el número a convertir a la pila. Esto es conveniente pues vamos a modificar ax más adelante.
        push bx     ; Metemos la base a la que queremos convertir a la pila. Esto es conveniente pues vamos a modificar bx más adelante.

        mov dx,0    ; Limpiamos DX. Esto nos sirve para siempre tener el residuo en 0 al entrar al procedimiento.
        mov cx,0    ; Limpiamos CX. Esto nos sirve para iniciar nuestro contador de dígitos en 0 al entrar al procedimiento.

        ; Aquí inicia el procedimiento de separar los dígitos
sepr:   mov dx,0    ; Limpiamos el residuo en cada jump
        div bx      ; Dividimos nuestro número (AX) entre nuestra base (BX)
        push dx     ; Guardamos el residuo en la pila
        inc cx      ; Incrementamos en 1 la cantidad de dígitos
        cmp ax,0    ; Revisamos si todavía hay algo que dividir
        jne sepr    ; Volvemos a dividir si AX no es 0

impr:   pop dx      ; Sacamos el residuo de la pila
        cmp dx,9    ; Verificamos si el número que tenemos es menor a 10
        jbe num      ; Si lo es, tenemos un dígito al que solamente le sumamos 30h para tener su equivalente ASCII
        add dx,07h  ; Si es mayor a 9, tenemos una letra, le sumamos 7h para convertir nuestro número
num:    add dx,30h  ; Le sumamos 30h (ó 48d) para convertir el dígito a su equivalente en ASCII
        mov ah,02h  ; Llamamos al servicio de impresión de caracter
        int 21h     ; Invocamos la interrupción 21h de DOS
        loop impr   ; Repetimos hasta que CX sea 0

        pop ax      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
        pop bx      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
        ret
endp
END
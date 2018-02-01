.MODEL small
.STACK 100h

.DATA
        msg     db      "Numero en base original: $"
        msb     db      "Numero en base convertida: $"
.CODE
        mov ax,@data
        mov ds,ax

        lea dx,msg
        mov ah,09h
        int 21h

        mov ax,0034h
        mov bx,10h
        call printNumBaseX

        mov dl,0Dh
        mov ah,02h
        int 21h

        mov dl,0Ah
        mov ah,02h
        int 21h

        lea dx,msb
        mov ah,09h
        int 21h

        mov ax,0034h
        mov bx,10h
        call printNumBaseX

        mov ah,04ch
        mov al,0
        int 21h

; Procedimiento: printNumBaseX
; Parámetros: Número almacenado en AX, base almacenada en BX
; Algoritmo para convertir número a base:
; do {
;   push dx % bx
;   numDigitos++
;   numero = numero / bx
; } while(numero > 0)

printNumBaseX proc near
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

        pop bx      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
        pop ax      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
        ret
endp
END
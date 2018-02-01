.MODEL small
.STACK 100h

LOCALS

printline macro
    mov ah,02h
    mov dl,0Ah
    int 21h

    mov dl,0Dh
    int 21h
endm

.DATA
    cad     dw      8 dup(?)
    atbr    dw      0
    PSP     dw      ?
    clen    equ     byte ptr es:[80h]
    cdat    equ     byte ptr es:[81h]

.CODE
        push ds
        mov ax,@data
        mov ds,ax
        pop PSP

        mov es,PSP

        lea bx,cdat
        lea si,cad

        inc bx

        call scmd
        printline
        call puts
        printline
        mov bx,10
        call atob
        printline
        mov bx,10
        mov ax,atbr
        call prntBase

        mov ah,4ch
        int 21h

scmd proc near
        push si
        push bx

save:   mov dx,es:[bx]
        mov [si],dl
        cmp dx,0Dh
        jz ecmd
        mov ah,02h
        int 21h
        inc bx
        inc si
        jmp save

ecmd:   pop bx
        pop si
        ret
endp

; Procedimiento: atoh (prospecta a convertirse en atob)
; Descripción: Convierte una cadena a su representación en hexadecimal
; Parámetros:
;           - si: apuntador a la cadena
;           - bx: base a la cual vamos a convertir
; Valor de retorno: Cadena convertida a base-n almacenada en ax
; Código C:
;
; int atoh(char *s, int base) {
;       int n = 0;
;       for(int i = 0; s[i] >= '0' && s[i] <= '9' || s[i] >= 'A' && s[i] <= 'F'; i++) {
;           n = 10 * n + (s[i] - '0');
;       }
; }

atob proc near
        push bx
        push si

        mov atbr,0
        printline

conv:   mov dx,[si]
        mov ah,02h
        int 21h
        inc si
        cmp dx,0Dh
        jz eatob
        cmp dx,'0'
        jb eatob
        cmp dx,'9'
        jg eatob
        mul bx
        sub dx,30h
        add atbr,dx
        jmp conv

eatob:  pop si
        pop bx
        ret
endp

prntBase proc
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
        jbe num     ; Si lo es, tenemos un dígito al que solamente le sumamos 30h para tener su equivalente ASCII
        add dx,07h  ; Si es mayor a 9, tenemos una letra, le sumamos 7h para convertir nuestro número
num:    add dx,30h  ; Le sumamos 30h (ó 48d) para convertir el dígito a su equivalente en ASCII
        mov ah,02h  ; Llamamos al servicio de impresión de caracter
        int 21h     ; Invocamos la interrupción 21h de DOS
        loop impr   ; Repetimos hasta que CX sea 0

        pop ax      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
        pop bx      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
        ret
endp

putchar proc near
        push dx

        mov ah,02h
        int 21h

        pop dx
        ret
endp

puts proc near
        push si

putc:   mov dl,[si]
        cmp dl,0Dh
        jz fins
        call putchar
        inc si
        jmp putc

fins:   pop si
        ret
endp
END
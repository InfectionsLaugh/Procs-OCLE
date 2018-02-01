print macro m
    mov ah,09h
    mov dx,offset m
    int 21h
endm

printLine macro
    mov ah,02h
    mov dl,0ah
    int 21h

    mov ah,02h
    mov dl,0dh
    int 21h
endm

.MODEL small
    .STACK 100h

    LOCALS

    .DATA
        aMes    db      "Cantidad de a: $"
        eMes    db      "Cantidad de e: $"
        iMes    db      "Cantidad de i: $"
        oMes    db      "Cantidad de o: $"
        uMes    db      "Cantidad de u: $"
        as      dw      0                   ; Contador de as
        ees     dw      0                   ; Contador de es
        is      dw      0                   ; Contador de is
        os      dw      0                   ; Contador de os
        us      dw      0                   ; Contador de us
        arra    dw      100 dup(?)
        clen    equ     byte ptr es:[80h]   ; Dirección que nos da los bytes (caracteres) que hay en la consola
        cdat    equ     byte ptr es:[81h]   ; Contenido de la cadena en la consola
        PSP     dw      ?                   ; Variable que usaremos para cargar la dirección del PSP (Program Segment Prefix)

    .CODE
        push ds         ; Guardamos la dirección del PSP (Program Segment Prefix) en la pila
        mov ax,@data    ; Cargamos la dirección del segmento de datos
        mov ds,ax       ; La cargamos en el registro DS
        pop PSP         ; Recuperamos la dirección de nuestro PSP

        mov es,PSP      ; Lo cargamos en el registro ES, que es el que nos va a permitir manipular la información del PSP

        lea bx,cdat     ; Cargamos el offset de los datos de la consola en BX

        inc bx          ; Nos movemos al siguiente caracter de la cadena (si no lo hacemos se nos imprime un espacio en blanco al principio)
        mov cx,0        ; Línea sin usar

prCmd:  mov dx,es:[bx]  ; Metemos el primer caracter de la línea de comandos en DX
        cmp dx,0Dh      ; Verificamos si el caracter corresponde a un retorno de carro; si es así nos movemos al final, ya terminamos
        je  fin         ; Saltamos al final del programa
incr:   mov ah,02h      ; Llamamos al servicio de salida de caracter en STDOUT
        call cVocal     ; Contamos las vocales que hay en la cadena
        int 21h         ; Invocamos interrupción 21h de DOS
        inc bx          ; Incrementamos BX para obtener el siguiente caracter de la consola
        jmp prCmd       ; Repetimos

        ; Imprimimos los contadores de vocales
fin:    printLine       ; Imprimimos una línea en blanco
        print aMes      ; Imprimimos cadena

        mov ax,as       ; Copiamos el valor del contador de as en ax
        mov bx,10       ; Base a usar para imprimir contador 
        call prntBase   ; Imprimimos el número
        ; A partir de aquí se repite lo de arriba.
        ; Se podría mejorar usando un arreglo, pero con que funcione está bien :P
        printLine

        print eMes

        mov ax,ees
        mov bx,10
        call prntBase
        printLine

        print iMes

        mov ax,is
        mov bx,10
        call prntBase
        printLine

        print oMes

        mov ax,os
        mov bx,10
        call prntBase
        printLine

        print uMes

        mov ax,us
        mov bx,10
        call prntBase
        printLine

        mov ah,4ch
        mov al,0
        int 21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                       ;;;
;;;                                                                       ;;;
;;;                      INICIO DE PROCEDIMIENTOS                         ;;;
;;;                                                                       ;;;
;;;                                                                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Procedimiento: prntBase
; Parámetros: Número almacenado en AX, base almacenada en BX
; Algoritmo para convertir número a base:
; do {
;   push dx % bx
;   numDigitos++
;   numero = numero / bx
; } while(numero > 0)

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

; Procedimiento: printArr
; Parámetros: Dirección de inicio de array dado por SI. Longitud dada por CX
; Este procedimiento imprime los valores guardados en un arreglo

printArr proc
        push si     ; Guardamos SI en la pila. Esto se hace porque va a ser modificado y queremos recuperar el valor original después
        push cx     ; Guardamos CX en la pila. Esto es para no perder la cuenta original de cuantos elementos hay en el arreglo

imp:    mov ax,[si] ; Copiamos el primer valor de SI en ax
        add ax,30h  ; Le sumamos 30h para obtener su equivalente en ASCII
        mov dx,ax   ; Lo copiamos a DX para prepararlo para impresión
        mov ah,02h  ; Llamamos al servicio de impresión de caracter de DOS
        int 21h     ; Invcamos a la interrupción 21h de DOS
        add si,2    ; Le sumamos 2 a SI para obtener el siguiente valor, dado que en las posiciones impares hay 0's
        sub cx,2    ; Disminuimos CX en 2 para llevar la cuenta correcta de elementos en el arreglo
        cmp cx,0    ; Comparamos con 0 para saber si ya terminamos
        jnz imp     ; Si todavía no es 0, tomamos el siguiente valor del arreglo

        pop si      ; Recuperamos valor de SI.
        pop cx      ; Recuperamos valor de CX
        ret
endp

; Procedimiento: loadArr
; Parámetros: arra, arreglo sobre el cual trabajar. CX / 2, número de elementos
; Este procedimiento llena un arreglo con valores de 0 a N

loadArr proc
        push cx             ; Guardamos CX en la pila porque va a ser modificado y queremos recuperar su valor después
        mov ax,0            ; Valor de inicio del arreglo

lda:    mov arra[bx],ax     ; Guardamos el valor de AX en el arreglo de memoria direccionado por arra en el elemento BX
        inc ax              ; Incrementamos AX en 1 para tener el siguiente elemento a guardar
        add bx,2            ; Incrementamos BX en 2 para ir a la siguiente posición. Se aumenta en 2 porque el tamaño de la palabra es de 2 bytes
        loop lda            ; Repetimos hasta que CX = 0

        pop cx              ; Recuperamos el valor de nuestro contador
        ret
endp

; Procedimiento: cVocal
; Paraámetros: 
;             - dl: Caracter a comparar
;             - as: Contador de vocal a
;             - ees: Contador de vocal e
;             - is: Contador de vocal i
;             - os: Contador de vocal o
;             - us: Contador de vocal u
;
; Descripción: Este procedimiento nos cuenta las vocales individuales de una cadena

cVocal proc
        push dx         ; Cargamos el caracter en la pila

        or dx,20h       ; Lo convertimos a minúscula (esto en caso de que nos llegue una letra mayúscula)

        ; Inicio de nuestro switch case
casea:  cmp dl,'a'      ; Comparamos si es la letra A
        jnz casee       ; Si no lo es, nos brincamos al siguiente case
esa:    inc as          ; Pero si sí lo es, incrementamos la cuenta de las A
casee:  cmp dl,'e'      ; Comparamos si es la letra E
        jnz casei       ; Si no lo es, nos brincamos al siguiente case
ese:    inc ees         ; Pero si sí lo es, incrementamos la cuenta de las E
casei:  cmp dl,'i'      ; Comparamos con la siguiente vocal
        jnz caseo       ; Lo mismo que con los casos anteriores
ei:     inc is          ; Lo mismo que con los casos anteriores
caseo:  cmp dl,'o'      ; Comparamos con la siguiente vocal
        jnz caseu       ; Lo mismo que con los casos anteriores
eso:    inc os          ; Lo mismo que con los casos anteriores
caseu:  cmp dl,'u'      ; Comparamos con la última vocal
        jnz def         ; Si no es ninguna vocal nos brincamos al final
esu:    inc us          ; Lo mismo que con los casos anteriores

def:    pop dx          ; Recuperamos el caracter guardado
        ret
endp
END
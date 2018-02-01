.MODEL small
.STACK 100h

INCLUDE milib.inc

.DATA
  cap   db    "Captura un numero: ",0
  capt  db    "Byte capturado: ",0
  str1  db    "Cadena 1: ",0
  str2  db    "Cadena 2: ",0
  cad1  db    "Organizacion de Computadoras y Lenguaje Ensamblador",0
  cad2  db    0

.CODE
      mov ax,@data
      mov ds,ax

      call clrscr

      lea dx,cap
      call puts

      call getHexByte

      call printline

      push ax

      lea dx,capt
      call puts

      pop ax

      mov bx,10h
      call printNumBaseX

      ; lea dx,str1
      ; call puts
      ; lea dx,cad1
      ; call puts

      ; call printline

      ; lea dx,str2
      ; call puts
      ; lea dx,cad2
      ; call puts

      ; call printline
      ; call printline

      ; lea bx,cad1
      ; lea dx,cad1
      ; call strlen ; strlen devuelve la cantidad de caracteres en la cadena en el registro CX
      ; lea dx,cad2
      ; call copiaMemoria

      ; lea dx,str2
      ; call puts
      ; lea dx,cad2
      ; call puts

      mov ah,4ch
      mov al,0
      int 21h

getHexByte PROC near
        push bx
        push cx
        push dx

        mov bx,0
        mov dx,0

leeNum: cmp bx,2
        je retu
        mov ah,01h
        int 21h
        cmp al,0Dh
        je retu
        cmp al,08h
        je borra
        cmp al,'0'
        jb esA
        cmp al,'9'
        ja esA
        jmp save
esA:    cmp al,'A'
        jb esm
        cmp al,'F'
        ja esm
        jmp save
esm:    cmp al,'a'
        jb borrac
        cmp al,'f'
        ja borrac
        xor al,20h
        jmp save
save:   cmp al,'9'
        jbe snum
        sub al,07h
snum:   sub al,30h
        cmp bx,0
        ja sln
        mov cl,4
        shl al,cl
sln:    add dl,al
        inc bx
        mov al,0
        jmp leeNum
borrac: mov ah,02h
        mov dl,08h
        int 21h
        mov ah,02h
        mov dl,' '
        int 21h
        mov dl,08h
        int 21h
        mov dl,0
        jmp leeNum
borra:  cmp bx,0
        jne red
        mov ah,02h
        mov dl,' '
        int 21h
        mov dl,0
        jmp leeNum
red:    mov ah,02h
        mov dl,' '
        int 21h
        mov dl,08h
        int 21h
        dec bx
        mov dl,0
        jmp leeNum

retu:   mov al,dl
        mov ah,0
        
        pop dx
        pop cx
        pop bx
        ret
ENDP

printline PROC near
        push dx
        push ax

        mov dl,0Dh
        mov ah,02h
        int 21h

        mov dl,0Ah
        mov ah,02h
        int 21h

        pop ax
        pop dx

        ret
ENDP

copiaMemoria PROC near
        push ax
        push bx
        push cx
        push dx

        mov di,dx

copia:  mov ax,[bx]
        mov [di],ax
        inc di
        inc bx
        loop copia

        pop dx
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
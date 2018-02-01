_TEXT segment byte public 'CODE'
assume cs:_TEXT

strlen PROC near
        push dx
        push di

        mov di,dx
        mov cx,0

cuenta: mov dl,[di]
        cmp dl,0
        je finlen
        inc cx
        inc di
        jmp cuenta

finlen: pop di
        pop dx
        ret
ENDP

puts PROC near
        push ax
        push dx
        push di

        mov di,dx

impr:   mov dl,[di]
        cmp dl,0
        je fin
        mov ah,02h
        int 21h
        inc di
        jmp impr

fin:    pop di
        pop dx
        pop ax
        ret
ENDP

prntBase PROC near
        push ax     ; Metemos el número a convertir a la pila. Esto es conveniente pues vamos a modificar ax más adelante.
       push bx     ; Metemos la base a la que queremos convertir a la pila. Esto es conveniente pues vamos a modificar bx más adelante.
        push cx
        push dx

        mov dx,0    ; Limpiamos DX. Esto nos sirve para siempre tener el residuo en 0 al entrar al procedimiento.
        mov cx,0    ; Limpiamos CX. Esto nos sirve para iniciar nuestro contador de dígitos en 0 al entrar al procedimiento.

        ; Aquí inicia el procedimiento de separar los dígitos
sepr:   mov dx,0    ; Limpiamos el residuo en cada jump
        div bx      ; Dividimos nuestro número (AX) entre nuestra base (BX)
        push dx     ; Guardamos el residuo en la pila
        inc cx      ; Incrementamos en 1 la cantidad de dígitos
        cmp ax,0    ; Revisamos si todavía hay algo que dividir
        jne sepr    ; Volvemos a dividir si AX no es 0

imprn:  pop dx      ; Sacamos el residuo de la pila
        cmp dx,9    ; Verificamos si el número que tenemos es menor a 10
        jbe num     ; Si lo es, tenemos un dígito al que solamente le sumamos 30h para tener su equivalente ASCII
        add dx,07h  ; Si es mayor a 9, tenemos una letra, le sumamos 7h para convertir nuestro número
num:    add dx,30h  ; Le sumamos 30h (ó 48d) para convertir el dígito a su equivalente en ASCII
        mov ah,02h  ; Llamamos al servicio de impresión de caracter
        int 21h     ; Invocamos la interrupción 21h de DOS
        loop imprn   ; Repetimos hasta que CX sea 0

        pop dx      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
        pop cx      ; Tomamos de nuevo el valor que ya estaba almacenado en la pila.
        pop bx
        pop ax
        ret
ENDP

gotoxy PROC near
        push ax
        push dx

        mov ah,02h
        int 10h

        pop dx
        pop ax
        ret
ENDP

clrscr PROC near
        push ax

        mov ah,0
        mov al,3
        int 10h

        pop ax
        ret
ENDP

getNum PROC near
        push ax
        push bx
        push cx
        push dx         ; Guardamos la posición inicial de la cadena en la pila para al terminar saber desde donde empezar a imprimir

        mov di,dx       ; Para poder direccionar a memoria tenemos que usar otro registro diferente a DX
        mov bx,dx       ; Usado más adelante para validaciones

leeNum: mov ah,01h      ; Leemos caracter del teclado
        int 21h         ;
        cmp al,0Dh      ; Verificamos si el siguiente caracter que nos llegó es un CR (carriage return)
        je retu         ; Si sí lo es, es un indicador de que ya terminamos de capturar y terminamos
        cmp al,08h      ; Ahora verificamos si lo que se oprimió fue la tecla Backspace
        je borra        ; Si lo fue, nos saltaremos a la parte de borrar caracter
        cmp al,'0'      ; Verificamos que el caracter leído sea uno de los permitidos (un dígito)
        jb borrac       ; Si no lo es, borramos de la pantalla
        cmp al,'9'      ; 
        ja borrac       ; 
        mov [di],al     ; Si cumple con todas las condiciones anteriores, podemos guardar el caracter leído en memoria
        inc di          ; Incrementamos DI para poder apuntar a la siguiente dirección de memoria en donde guardar el dígito
        jmp leeNum      ; Nos saltamos a leer el siguiente caracter
borrac: mov ah,02h      ; ETIQUETA DE BORRADO DE CARACTER EN CASO DE QUE SEA ALGO DIFERENTE AL RANGO DEL 0 - 9
        mov dl,08h      ; Imprimimos un backspace
        int 21h         ;
        call backspace  ; Llamamos al Procedimiento backspace que nos borra un caracter de la pantalla por completo
        jmp leeNum      ; Volvemos a leer un caracter
borra:  cmp di,bx       ; Comparamos si DI está al inicio de la dirección de la cadena 
        jne red         ; Si no lo está, podemos borrar y decrementar DI
        mov ah,02h      ; Pero si lo está, no podemos borrar más caracteres, tenemos que imprimir un espacio y borrarlo
        mov dl,' '      ;
        int 21h         ; 
        jmp leeNum      ; Leemos otro caracter
red:    call backspace  ; Borrarmos caracter si no estamos al inicio de la cadena
        dec di          ; Reducimos DI en 1 para poder sustituir este caracter en la siguiente leída del teclado
        jmp leeNum      ; Leemos otro caracter
 
retu:   mov al,0        ; Copiamos el terminador NULL en AL para poderlo agregar al final de la cadena
        mov [di],al  ; Guardamos el valor de AL (terminador NULL) en la última posición de la cadena para saber hasta donde se va a imprimir

        pop dx          ; Sacamos la posición inicial de la cadena de la pila
        pop cx
        pop bx
        pop ax
        ret
ENDP

getAlpha PROC near
        push ax
        push bx
        push cx
        push dx         ; Guardamos la posición inicial de la cadena en la pila para al terminar saber desde donde empezar a imprimir

        mov di,dx       ; Para poder direccionar a memoria tenemos que usar otro registro diferente a DX
        mov bx,dx       ; Usado más adelante para validaciones

leeLet: mov ah,01h      ; Leemos caracter del teclado
        int 21h         ;
        cmp al,0Dh      ; Verificamos si el siguiente caracter que nos llegó es un CR (carriage return)
        je cad          ; Si sí lo es, es un indicador de que ya terminamos de capturar y terminamos
        cmp al,08h      ; Ahora verificamos si lo que se oprimió fue la tecla Backspace
        je borrad       ; Si lo fue, nos saltaremos a la parte de borrar caracter
        cmp al,'A'      ; Verificamos que el caracter leído sea uno de los permitidos (un dígito)
        jb esMin        ; Si no lo es, borramos de la pantalla
        cmp al,'Z'      ;
        ja esMin        ;
        jmp guar
esMin:  cmp al,'a'
        jb borral
        cmp al,'z'
        ja borral
        jmp guar
guar:   mov [di],al  ; Si cumple con todas las condiciones anteriores, podemos guardar el caracter leído en memoria
        inc di          ; Incrementamos DI para poder apuntar a la siguiente dirección de memoria en donde guardar el dígito
        jmp leeLet      ; Nos saltamos a leer el siguiente caracter
borral: mov ah,02h      ; ETIQUETA DE BORRADO DE CARACTER EN CASO DE QUE SEA ALGO DIFERENTE AL RANGO DEL 0 - 9
        mov dl,08h      ; Imprimimos un backspace
        int 21h         ;
        call backspace  ; Llamamos al Procedimiento backspace que nos borra un caracter de la pantalla por completo
        jmp leeLet      ; Volvemos a leer un caracter
borrad: cmp di,bx       ; Comparamos si DI está al inicio de la dirección de la cadena 
        jne redu        ; Si no lo está, podemos borrar y decrementar DI
        mov ah,02h      ; Pero si lo está, no podemos borrar más caracteres, tenemos que imprimir un espacio y borrarlo
        mov dl,' '      ;
        int 21h         ;
        jmp leeLet      ; Leemos otro caracter
redu:   call backspace  ; Borrarmos caracter si no estamos al inicio de la cadena
        dec di          ; Reducimos DI en 1 para poder sustituir este caracter en la siguiente leída del teclado
        jmp leeLet      ; Leemos otro caracter
 
cad:    mov al,0        ; Copiamos el terminador NULL en AL para poderlo agregar al final de la cadena
        mov [di],al  ; Guardamos el valor de AL (terminador NULL) en la última posición de la cadena para saber hasta donde se va a imprimir

        pop dx          ; Sacamos la posición inicial de la cadena de la pila
        pop cx
        pop bx
        pop ax
        ret
ENDP

backspace PROC near
        push ax
        push dx

        mov ah,02h
        mov dl,' '
        int 21h
        mov dl,08h
        int 21h

        pop dx
        pop ax
        ret
ENDP

bubbleSort PROC near
      push ax
      push bx
      push cx
      push dx
      push di
      push si

      mov di,dx

      xor ax,ax
      xor bx,bx ; j = 0
      xor dx,dx
      mov al,cl
      dec al
      mov dl,al
      dec dl

      xor si,si       ; i = 0
exte: cmp si,dx       ; i < len - 1
      jae fbs         ;
      mov bx,si       ; j = i
inte: cmp bx,ax       ; j < len
      jae nxte        ; Vuelve a for exterior
      push bx         ; 
      mov bx,si       ;
      mov ch,[di+bx]  ; arr[i]
      pop bx          ;
      mov cl,[di+bx]  ; arr[j]
      cmp ch,cl       ; arr[i] > arr[j]
      ja swtc         ;
nxti: inc bx          ; j++
      jmp inte        ; Repite for interior
swtc: xchg ch,cl      ; temp = arr[i]
      push bx         ;
      mov bx,si       ;
      mov [di+bx],ch  ; arr[i] = arr[j]
      pop bx          ;
      mov [di+bx],cl  ; arr[j] = arr[i]
      jmp nxti        ; j++
nxte: inc si          ; i++
      jmp exte        ; Repite for exterior

fbs:  pop si
      pop di
      pop dx
      pop cx
      pop bx
      pop ax
      ret
ENDP

prntLine PROC near
          push ax
          push dx

          mov dl,0dh
          mov ah,02h
          int 21h

          mov dl,0ah
          int 21h

          pop dx
          pop ax
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

putchar PROC near
        push ax
        push dx

        mov ah,02h
        int 21h

        pop dx
        pop ax
        ret
ENDP

_TEXT ends
  public strlen
  public puts
  public prntBase
  public gotoxy
  public clrscr
  public getNum
  public getAlpha
  public backspace
  public bubbleSort
  public prntLine
  public atoi
  public copiaMemoria
  public prntNum
  public putchar
END
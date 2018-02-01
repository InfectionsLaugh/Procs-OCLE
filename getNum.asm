.MODEL small
.STACK 100h

.DATA
  msg   db    "oso",0
  dig   dw    0
  men   db    "hola",0

.CODE
        push ds
        mov ax,@data
        mov ds,ax

        call clrscr

        lea dx,msg

        call palindromo
        add ah,30h
        mov dl,ah
        mov ah,02h
        int 21h
        
        mov ah,4ch
        mov al,0
        int 21h

strlen PROC
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

palindromo  PROC
        push dx

        mov di,dx
        mov bx,dx
        call strlen
        add bx,cx
        sub bx,1

pal:    cmp bx,di
        je siEs
        mov dh,[bx]
        mov dl,[di]
        cmp dh,dl
        jne finpal
        dec bx
        inc di
        jmp pal

siEs:   mov ah,1
        jmp vue
finpal: mov ah,0
vue:    pop dx
        ret
ENDP

;*****************************************************
;*                                                   *
;*                                                   *
;*                 PROCEDIMIENTOS                    *
;*                                                   *
;*                                                   *
;*****************************************************

;//////////////////////////////////////////////////////
; Procedimiento: gotoxy                            
;                                                  
; Parámetros: DH = renglón, DL = columna           
;                                                  
; Descripción: Establece el cursor en la posición  
;              dada por el registro DX. Se hace    
;              uso del servicio 2 de la            
;              interrupción 10h (llamadas al BIOS) 
;                                                  
;//////////////////////////////////////////////////////
gotoxy PROC
        push dx

        mov ah,02h
        int 10h

        pop dx
        ret
ENDP

;//////////////////////////////////////////////////////
; Procedimiento: clrscr                            
;                                                  
; Parámetros: ninguno                              
;                                                  
; Descripción: limpia la pantalla haciendo uso de  
;              la interrupción 10h, servicio 0.    
;              Se establece el modo de video       
;                                                  
;//////////////////////////////////////////////////////
clrscr PROC
        push ax

        mov ah,0
        mov al,3
        int 10h

        pop ax
        ret
ENDP

;//////////////////////////////////////////////////////
; Procedimiento: backspace                           
;                                                 
; Parámetros: ninguno                             
;                                                 
; Descripción: borra caracter de la pantalla      
;              imprimiendo un espacio seguido del 
;              caracter 8 (backspace)             
;                                                 
;//////////////////////////////////////////////////////
backspace PROC
        push dx

        mov ah,02h
        mov dl,' '
        int 21h
        mov dl,08h
        int 21h

        pop dx
        ret
ENDP

puts PROC
        push dx

        mov di,dx

impr:   mov dl,es:[di]
        cmp dl,0
        je fin
        mov ah,02h
        int 21h
        inc di
        jmp impr

fin:    pop dx
        ret
ENDP

;//////////////////////////////////////////////////////
; Procedimiento: leeDig                            
;                                                  
; Parámetros:                                      
;   Entrada: Apuntador a la cadena guardado en DX  
;   Salida: Apuntador a la cadena guardado en DX   
;                                                  
; Descripción: lee una cadena que consta solamente de
;              dígitos, los cuales son almacenados en
;              memoria usando como apuntador a DI, que
;              toma como valor de inicio un apuntador
;              a una cadena dado por DX. Esta rutina
;              termina la cadena en 0.
;                                                  
;//////////////////////////////////////////////////////
getNum PROC
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
        mov es:[di],al  ; Si cumple con todas las condiciones anteriores, podemos guardar el caracter leído en memoria
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
        mov es:[di],al  ; Guardamos el valor de AL (terminador NULL) en la última posición de la cadena para saber hasta donde se va a imprimir

        pop dx          ; Sacamos la posición inicial de la cadena de la pila
        ret
ENDP

getAlpha PROC
        push dx         ; Guardamos la posición inicial de la cadena en la pila para al terminar saber desde donde empezar a imprimir

        mov di,dx       ; Para poder direccionar a memoria tenemos que usar otro registro diferente a DX
        mov bx,dx       ; Usado más adelante para validaciones

leeLet: mov ah,01h      ; Leemos caracter del teclado
        int 21h         ;
        cmp al,0Dh      ; Verificamos si el siguiente caracter que nos llegó es un CR (carriage return)
        je cad          ; Si sí lo es, es un indicador de que ya terminamos de capturar y terminamos
        cmp al,08h      ; Ahora verificamos si lo que se oprimió fue la tecla Backspace
        je borrad       ; Si lo fue, nos saltaremos a la parte de borrar caracter
        xor al,20h
        cmp al,'A'      ; Verificamos que el caracter leído sea uno de los permitidos (un dígito)
        jb borral       ; Si no lo es, borramos de la pantalla
        cmp al,'z'      ;
        ja borral       ;
        xor al,20h
        mov es:[di],al  ; Si cumple con todas las condiciones anteriores, podemos guardar el caracter leído en memoria
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
        mov es:[di],al  ; Guardamos el valor de AL (terminador NULL) en la última posición de la cadena para saber hasta donde se va a imprimir

        pop dx          ; Sacamos la posición inicial de la cadena de la pila
        ret
ENDP
END

dosseg
.MODEL small
.CODE
public _myputchar
_myputchar PROC
           push bp
           mov bp,sp
           mov dl,[bp+4]
           mov ah,02h
           int 21h
           pop bp
           ret
_myputchar ENDP
END
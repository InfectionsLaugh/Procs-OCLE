dosseg
.MODEL small
.CODE
public _miputs
_miputs PROC
        push bp
        mov bp,sp
sigc:   mov dl,[bp+4]
        mov ah,02h
        int 21h
        inc bp
        jmp sigc
fnpts:  pop bp
        ret
_miputs ENDP
END
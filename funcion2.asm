.MODEL small
.STACK 100h

.DATA
	tmp 	db 		"Cadena$"
.CODE
		mov ax,@data
		mov ds,ax

		mov ax,1234h
		call putNibbleHex

		mov ah,4ch
		int 21h

putNibbleHex proc
		push ax
		push dx

		and al,000fh
		cmp al,0ah
		jb num
		add ax,07h
num: 	add al,30h
		mov dl,al
		mov ah,02h
		int 21h

		pop dx
		pop ax
		ret
endp

END
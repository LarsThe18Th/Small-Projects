format binary

org 100h
use16

	;Set Mode 25x80
	;mov ax,3
	;mov	ah, 0
	;int	10h

	;Clear screen
	mov	bl, 25
row:
	mov	ah, 2
	mov	dl, 10
	int	21h
	dec	bl
	jnz	row

	;Set cursor to 0,0
	mov	dx, 00h
	mov	ah, 02h
	mov	bh, 00h
	int	10h

	mov bx,message			; movs text pointer to dx
myloop: 
	mov al,[bx]
	inc bx
	cmp al,0
	je  quit

	;Coloring
	push bx

	; 1,2,3 -> 15,08,07  -> Char "Û"
	;     4 -> color 0,0 -> Char " "
	
	mov ah,09h
	mov bh,0

	;Check if 1,2,3,4
	mov	bl, 00001111b
	cmp	al, "1"
	je	number
	
	mov	bl, 00001000b
	cmp	al, "2"
	je	number

	mov	bl, 00000111b
	cmp	al, "3"
	je	number

	mov	bl, 00000000b
	cmp	al, "4"
	je	number2

	mov	bl, 00011111b		; Color atributes 
	jmp	normal

number:
	mov	al, "Û"
	jmp	normal

number2:
	mov	al, " "
normal:

	mov cx,0001h			; Amount of colored chars
	int 10h
			
	; Cursor Shifting
	mov	ah, 03h
	mov	bh, 00h
	int	10h

	; Check EOL
	cmp	dl, 80
	jne	linefeed

	mov	dl, 00h
	inc	dh

linefeed:
	
	inc	dl
	mov	ah, 02h
	mov	bh, 00h
	int	10h

	pop bx

	jmp myloop
	
quit:
	;Print LF
	mov	ah, 2
	mov	dl, 10
	int	21h
	

	;Exit to Dos
	mov ah, 04ch
	mov al, 00
	int 21h

	;	message db "Hello, world!"
	;	db 10,13,0

message db "   _____ _____ _   _ _____ _____                  111111111111111111111111111111"
	db "  / ____|_   _| \ | |_   _/ ____|                 111111111111333311111111111111"
	db " | |      | | |  \| | | || |                      111111111132311111131111111111"
	db " | |____ _| |_| |\  |_| || |____                  132311111132111111122111111111"
	db "  \_____|_____|_| \_|_____\_____|                 122423111221141111122111111111"
	db "                                                  111244423231111114133111111111"
	db "        _____            __                       111113233111111111133111111111"
	db "       / ___/__  _______/ /____  ____ ___  _____  111111111111111111113113333311"
	db "       \__ \/ / / / ___/ __/ _ \/ __ `__ \/ ___/  123111111111111111111132222441"
	db "      ___/ / /_/ (__  ) /_/  __/ / / / / (__  )   124311111111111111111111111441"
	db "     /____/\__  /____/\__/\___/_/ /_/ /_/____/    134211111111111111111111111441"
	db "          /____/                                  112411111111111111111111112431"
	db "                                                  113411111111111111111111124211"
	db "         Ghost Boot-CD                            111243111111111111111111344311"
	db "                                                  111242111111111111111113443111"
	db "                                                  111342111111111111111134431111"
	db "                                                  111143111111111111111244311111"
	db "                                                  111143111111111111124431111111"
	db "                                                  111243111111111112443111111111"
	db "                                                  111323111111112442211111111111"
	db "                                                  113231111322244331111111111111"
	db "                                                  124444444423331111111111111111"
	db "                                                  111111111111111111111111111111"
	db 0

; Ghost BootLogo v0.2

format binary

org 100h
use16

	;Clear screen
	mov	bl, 25
row:
	mov	ah, 2
	mov	dl, 10
	int	21h
	dec	bl
	jnz	row
; --------------------------

					;Set cursor to 0,0
					mov	dx, 00h
					call noeol
	
;Main
					mov bx,message					; Load TextPointer
myloop:
					mov al,[bx]						; Read from TextPointer

					cmp al,255
					jz ending						; End if Read 255

						; Single / Multi
						btr	ax,7					; Bit Test and Reset
						jc multi					; Jump if Carry is set


single:
					mov cl,01						; Chars to Print
					jmp types

multi:

					inc bx
					mov cl,[bx]						; Read from TextPointer					

types:
					push bx							; Save bx					
					cmp al,31						; Chars to Print
					jnc askii

karak:
					mov bl,al						; Color = Ascii value
					mov al,219						; set Char "█"
					jmp conclude

askii:
					mov bl,31						; Color = 31 Front = 0fh / Back = Blue 01h

conclude:
					call writeit
					pop bx
					inc bx

					jmp myloop


ending:

					; Exit to Dos
					mov ah, 04ch
					mov al, 00
					int 21h
					; END



;Sub Writeit ---------------------------------------------------------------------------------------------------------------

writeit:
					push cx
					; AH=09h  AL = Character, BH = Page Number, BL = Color, CX = Number of times to print character
					mov ah,09h						; Write character and attribute at cursor position 
					mov bh,0						; Page 0
					int 10h

					; Get cursor position and shape
					; AH=03h  BH = Page Number  RET -> AX = 0, CH = Start scan line, CL = End scan line, DH = Row, DL = Column
					mov ah,03h
					int 10h

					pop cx
					mov ch,00h						; Discard High Byte
					add dl,cl
					cmp dl,80						; End of line ?

					jne noeol
						inc dh						; Increase Row
						mov dl,0h					; Reset Colum


noeol:
					; Set cursor position  
					; AH=02h  BH = Page Number, DH = Row, DL = Column
					mov ah,02h 
					int 10h
					ret

; Data Segment --------------------------------------------------------------------------------------------------------------
message:

					db " "+128,3,"_"+128,5," ","_"+128,5," ","_"," "+128,3,"_"," ","_"+128,5," ","_"+128,5," "+128,18,0fh+128,30
					db "  / ","_"+128,4,"|_"," "+128,3,"_| \ | |_"," "+128,3,"_/ ","_"+128,4,"|"," "+128,17,0fh+128,12,07h+128,4,0fh+128,14
					db " | |"," "+128,6,"| | |  \| | | || |"," "+128,22,0fh+128,10,07h,08h,07h,0fh+128,6,07h,0fh+128,10
					db " | |","_"+128,4," _| |_| |\  |_| || |","_"+128,4," "+128,18,0fh,07h,08h,07h,0fh+128,6,07h,08h,0fh+128,7,08h,08h,0fh+128,9
					db "  \","_"+128,5,"|","_"+128,5,"|_| \_|","_"+128,5,"\","_"+128,5,"|"," "+128,17,0fh,08h,08h,00h,08h,07h,0fh+128,3,08h,08h,0fh,0fh,00h,0fh+128,5,08h,08h,0fh+128,9
					db " "+128,50,0fh+128,3,08h,00h+128,3,08h,07h,08h,07h,0fh+128,6,00h,0fh,07h,07h,0fh+128,9
					db " "+128,8,"_"+128,5," "+128,12,"__"," "+128,23,0fh+128,5,07h,08h,07h,07h,0fh+128,10,07h,07h,0fh+128,9
					db " "+128,7,"/ ","_"+128,3,"/__  ","_"+128,7,"/ /","_"+128,4,"  ","_"+128,4," ","_"+128,3,"  ","_"+128,5,"  ",0fh+128,20,07h,0fh,0fh,07h+128,5,0fh,0fh
					db " "+128,7,"\__ \/ / / / ","_"+128,3,"/ __/ _ \/ __ `__ \/ ","_"+128,3,"/  ",0fh,08h,07h,0fh+128,19,07h,08h+128,4,00h,00h,0fh
					db " "+128,6,"_"+128,3,"/ / /_/ (__  ) /_/  __/ / / / / (__  )"," "+128,3,0fh,08h,00h,07h,0fh+128,23,00h,00h,0fh
					db " "+128,5,"/","_"+128,4,"/\__  /","_"+128,4,"/\__/\","_"+128,3,"/_/ /_/ /_/","_"+128,4,"/"," "+128,4,0fh,07h,00h,08h,0fh+128,23,00h,00h,0fh
					db " "+128,10,"/","_"+128,4,"/"," "+128,34,0fh,0fh,08h,00h,0fh+128,22,08h,00h,07h,0fh
					db " "+128,50,0fh,0fh,07h,00h,0fh+128,21,08h,00h,08h,0fh,0fh
					db " "+128,9,"Ghost Boot-CD"," "+128,28,0fh+128,3,08h,00h,07h,0fh+128,18,07h,00h,00h,07h,0fh,0fh
					db " "+128,50,0fh+128,3,08h,00h,08h,0fh+128,17,07h,00h,00h,07h,0fh+128,3
					db " "+128,50,0fh+128,3,07h,00h,08h,0fh+128,16,07h,00h,00h,07h,0fh+128,4
					db " "+128,50,0fh+128,4,00h,07h,0fh+128,15,08h,00h,00h,07h,0fh+128,5
					db " "+128,50,0fh+128,4,00h,07h,0fh+128,13,08h,00h,00h,07h,0fh+128,7
					db " "+128,50,0fh+128,3,08h,00h,07h,0fh+128,11,08h,00h,00h,07h,0fh+128,9
					db " "+128,50,0fh+128,3,07h,08h,07h,0fh+128,8,08h,00h,00h,08h,08h,0fh+128,11
					db " "+128,50,0fh+128,2,07h,08h,07h,0fh+128,4,07h,08h+128,3,00h,00h,07h,07h,0fh+128,13
					db " "+128,50,0fh,08h,00h+128,8,08h,07h+128,3,0fh+128,16
					db " "+128,50,0fh+128,30
					db 00h+128,79
					db 255
					db "(c)2020 "
					dw 614Ch,7372h,5420h,6568h,3120h,5438h,2068h,2020h






















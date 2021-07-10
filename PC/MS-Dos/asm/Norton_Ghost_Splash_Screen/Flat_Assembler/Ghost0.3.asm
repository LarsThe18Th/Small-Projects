; Ghost BootLogo v0.3
;
; Changelog: 0.2
; - Included compression to shrink Data block with logo
; - Now assembles to a 720 bytes .COM file
;
; Changelog: 0.3
; - Converted Data block to hex values
; - Fixed bug in printing final Row 23 no CR/LF

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
					xor dx,dx						;mov	dx,00h
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
					mov ah,04ch
					mov al,00
					int 21h
					; END


;Sub Writeit ---------------------------------------------------------------------------------------------------------------

writeit:
					push cx
					; AH=09h  AL = Character, BH = Page Number, BL = Color, CX = Number of times to print character
					mov ah,09h						; Write character and attribute at cursor position 
					mov bh,0 						; Page 0
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
						cmp dh,23					; No LF in final Row
						je noeol
							inc dh					; Increase Row
							mov dl,0h				; Reset Colum
						

noeol:
					; Set cursor position  
					; AH=02h  BH = Page Number, DH = Row, DL = Column
					mov ah,02h 
					int 10h
					ret

; Data Segment --------------------------------------------------------------------------------------------------------------
message:

					db $A0,$03,$DF,$05,$20,$DF,$05,$20,$5F,$A0,$03,$5F,$20,$DF,$05,$20,$DF,$05,$A0,$12,$8F,$1E,$20,$20,$2F,$20,$DF,$04,$7C,$5F,$A0,$03,$5F,$7C,$20,$5C,$20,$7C,$20,$7C
					db $5F,$A0,$03,$5F,$2F,$20,$DF,$04,$7C,$A0,$11,$8F,$0C,$87,$04,$8F,$0E,$20,$7C,$20,$7C,$A0,$06,$7C,$20,$7C,$20,$7C,$20,$20,$5C,$7C,$20,$7C,$20,$7C,$20,$7C,$7C,$20
					db $7C,$A0,$16,$8F,$0A,$07,$08,$07,$8F,$06,$07,$8F,$0A,$20,$7C,$20,$7C,$DF,$04,$20,$5F,$7C,$20,$7C,$5F,$7C,$20,$7C,$5C,$20,$20,$7C,$5F,$7C,$20,$7C,$7C,$20,$7C,$DF
					db $04,$A0,$12,$0F,$07,$08,$07,$8F,$06,$07,$08,$8F,$07,$08,$08,$8F,$09,$20,$20,$5C,$DF,$05,$7C,$DF,$05,$7C,$5F,$7C,$20,$5C,$5F,$7C,$DF,$05,$5C,$DF,$05,$7C,$A0,$11
					db $0F,$08,$08,$00,$08,$07,$8F,$03,$08,$08,$0F,$0F,$00,$8F,$05,$08,$08,$8F,$09,$A0,$32,$8F,$03,$08,$80,$03,$08,$07,$08,$07,$8F,$06,$00,$0F,$07,$07,$8F,$09,$A0,$08
					db $DF,$05,$A0,$0C,$5F,$5F,$A0,$17,$8F,$05,$07,$08,$07,$07,$8F,$0A,$07,$07,$8F,$09,$A0,$07,$2F,$20,$DF,$03,$2F,$5F,$5F,$20,$20,$DF,$07,$2F,$20,$2F,$DF,$04,$20,$20
					db $DF,$04,$20,$DF,$03,$20,$20,$DF,$05,$20,$20,$8F,$14,$07,$0F,$0F,$87,$05,$0F,$0F,$A0,$07,$5C,$5F,$5F,$20,$5C,$2F,$20,$2F,$20,$2F,$20,$2F,$20,$DF,$03,$2F,$20,$5F
					db $5F,$2F,$20,$5F,$20,$5C,$2F,$20,$5F,$5F,$20,$60,$5F,$5F,$20,$5C,$2F,$20,$DF,$03,$2F,$20,$20,$0F,$08,$07,$8F,$13,$07,$88,$04,$00,$00,$0F,$A0,$06,$DF,$03,$2F,$20
					db $2F,$20,$2F,$5F,$2F,$20,$28,$5F,$5F,$20,$20,$29,$20,$2F,$5F,$2F,$20,$20,$5F,$5F,$2F,$20,$2F,$20,$2F,$20,$2F,$20,$2F,$20,$28,$5F,$5F,$20,$20,$29,$A0,$03,$0F,$08
					db $00,$07,$8F,$17,$00,$00,$0F,$A0,$05,$2F,$DF,$04,$2F,$5C,$5F,$5F,$20,$20,$2F,$DF,$04,$2F,$5C,$5F,$5F,$2F,$5C,$DF,$03,$2F,$5F,$2F,$20,$2F,$5F,$2F,$20,$2F,$5F,$2F
					db $DF,$04,$2F,$A0,$04,$0F,$07,$00,$08,$8F,$17,$00,$00,$0F,$A0,$0A,$2F,$DF,$04,$2F,$A0,$22,$0F,$0F,$08,$00,$8F,$16,$08,$00,$07,$0F,$A0,$32,$0F,$0F,$07,$00,$8F,$15
					db $08,$00,$08,$0F,$0F,$A0,$09,$47,$68,$6F,$73,$74,$20,$42,$6F,$6F,$74,$2D,$43,$44,$A0,$1C,$8F,$03,$08,$00,$07,$8F,$12,$07,$00,$00,$07,$0F,$0F,$A0,$32,$8F,$03,$08
					db $00,$08,$8F,$11,$07,$00,$00,$07,$8F,$03,$A0,$32,$8F,$03,$07,$00,$08,$8F,$10,$07,$00,$00,$07,$8F,$04,$A0,$32,$8F,$04,$00,$07,$8F,$0F,$08,$00,$00,$07,$8F,$05,$A0
					db $32,$8F,$04,$00,$07,$8F,$0D,$08,$00,$00,$07,$8F,$07,$A0,$32,$8F,$03,$08,$00,$07,$8F,$0B,$08,$00,$00,$07,$8F,$09,$A0,$32,$8F,$03,$07,$08,$07,$8F,$08,$08,$00,$00
					db $08,$08,$8F,$0B,$A0,$32,$8F,$02,$07,$08,$07,$8F,$04,$07,$88,$03,$00,$00,$07,$07,$8F,$0D,$A0,$32,$0F,$08,$80,$08,$08,$87,$03,$8F,$10,$A0,$32,$8F,$1E,$80,$50,$FF
					db "(c)'20 "
					dw 614Ch,7372h,5420h,6568h,3120h,5438h,2068h,2020h





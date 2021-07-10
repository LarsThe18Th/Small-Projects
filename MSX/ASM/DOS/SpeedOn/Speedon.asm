; Speedon.com v0.1
; Detect Panasonic and switch to 6Mhz
; Only works for Panasonic FS-A1WX/WSX/FX ID=8

	output speedon.com
	
	defpage 0,100h
	page 0
	code @ 100h

	
		ld a,8					;Set Panasonic 
		out (#40),a
		in a,(#40)				;Read back value
		cpl						;Invert Xor #FF
		cp 8					;Match ?
		jr nz,nopana
		
		xor a					;Set Speed On = 0
		out (#41),a
		ld de,msgspeedon
		jr print
		
nopana:	
		ld de,msgnopana
		
print:
		ld c,9					;Print text with textpointer de
		call 5
		ret

;------------------------------------------------
msgnopana:
		db "No Panasonic Found",10,13,"$"

msgspeedon:
		db "Speed On",10,13,"$"

nametag:
		dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
		db "(c)2014"
	end
; Speed.com v0.2
; Detect Panasonic and switch to 3.5Mhz or 6Mhz
; Only works for Panasonic FS-A1WX/WSX/FX ID=8

	output speed.com
	
	defpage 0,100h
	page 0
	code @ 100h

	
		ld a,8					;Set Panasonic 
		out (#40),a
		in a,(#40)				;Read back value
		cpl						;Invert Xor #FF
		cp 8					;Match ?
		jr nz,nopana
	
		ld a,(#0080)			;Get command line input Length
		or a					;Print error if length = 0
		jp nz,comline
			ld de,msgerror
			jr print		
		
comline:
		ld a,(#0082)			;Get command line input
		cp "0"
		jp nz,notzero
			ld de,msgspeedoff
			ld a,1				;Set Speed Off = 1
			jr setcpu

notzero:
		cp "1"
		jp nz,notone
			ld de,msgspeedon
			xor a				;Set Speed On = 0
			jr setcpu
		
notone:

		ld de,msgerror
		jr print
		
setcpu:
		out (#41),a
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
		
msgspeedoff:
		db "Speed Off",10,13,"$"
		
msgerror:
		db "Use speed 1 or speed 0",10,13,"$"

nametag:
		dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
		db "(c)2014"
	
	end
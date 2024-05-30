; 50Hz.com v0.1
; Switches to 50Hz 

	output 50Hz.com
	
	defpage 0,100h
	page 0
	code @ 100h

main:
		xor a						;Slot 0 (Not Expanded)
		ld hl,#2d					;Read value of $2d in slot 0 (BIOS)
		call $0c
		
		ld de,msx1
		or a						;Test if MSX1
		jp z,print

		ld a,(#ffe8)				;Read register 9
		set 1,a						;Set Bit 1(PAL)
	
wrtreg:
		ld (#ffe8),a				;Store new setting
		out	(#99),a					;Write to VDP R#9
		ld	A,9+128
		out	(#99),a

		ld de,hrtz
print:
		ld c,9						;Print TXT
		call 5
		ret

;------------------------------------------------
hrtz:	db "Now running @ 50Hz",10,13,"$"

msx1:
		db "MSX1 not allowed",10,13,"$"

nametag:
		dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
		db "(c)2014"
	
	end
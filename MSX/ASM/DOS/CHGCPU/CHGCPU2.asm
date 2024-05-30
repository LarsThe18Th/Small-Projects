; CHGCPU2.com v0.1
; Change MSX Turbo-r CPU Mode to R800 (DRAM)

	output CHGCPU2.com
	
	defpage 0,100h
	page 0
	code @ 100h

main:
		xor a						;Slot 0 (Not Expanded)		
		ld hl,#2d					;Reads the value of $2d in slot 0 (BIOS)
		call $0c					;RDSLT Read a value in another slot

		sub 3						;Test if Turbo-r
		jp z,foundtr
			ld de,notr
			jp print

foundtr:
		ld a,%10000010				;R800 (DRAM) Mode
		ld iy,(#fcc0)				;Inter-SlotCall
		ld ix,#0180					;BIOS CALL CHGCPU
		call $1c	
		ld de,newmode
print:
		ld c,9						;Print text with textpointer de
		call 5
		ret

;------------------------------------------------

newmode:
		db "Mode: R800 (DRAM)",10,13,"$"
		
notr:
		db "No Turbo-r Found",10,13,"$"

nametag:
		dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
		db "(c)2014"
	
	end
; GETCPU.com v0.1
; Change MSX Turbo-r CPU Mode to R800 (DRAM)

	output GETCPU.com
	
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
		ld iy,(#fcc0)				;Inter-SlotCall
		ld ix,#0183					;BIOS CALL CHGCPU
		call $1c	
		
		cp 0
		jp nz,mod1
			ld de,mode0
			jp print
mod1:
		cp 1
		jp nz,mod2
			ld de,mode1		
			jp print
mod2:
		ld de,mode2

print:
		ld c,9						;Print text with textpointer de
		call 5
		ret

;------------------------------------------------
mode0:
		db "Z80 (ROM) Mode",10,13,"$"
mode1:
		db "R800 (ROM) Mode",10,13,"$"
mode2:
		db "R800 (DRAM) Mode",10,13,"$"

notr:
		db "No Turbo-r Found",10,13,"$"

nametag:
		dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
		db "(c)2014"
	
	end
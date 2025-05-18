; CHGCPU.com v0.3
; Change CPU Mode for MSX Turbo-r
; 0 = Z80 (ROM) Mode
; 1 = R800 (ROM) Mode
; 2 = R800 (DRAM) Mode

	output CHGCPU.com
	
	defpage 0,100h
	page 0
	code @ 100h

main:
			ld a,(#0080)			;Get command line input Length 
			ld de,info			;Set info message
			or a				;if commandline input length = 0
			jp z,print			;Print info message

			xor a				;Slot 0 (Not Expanded)
			ld iy,(#fcc0)			;Inter-SlotCall
			ld ix,#0c			;BIOS CALL
			ld hl,#2d			;Read value of $2d in slot 0 (BIOS)
			call $1c

			sub 3				;Test if Turbo-r
			jp z,foundtr
				ld de,notr
				jp print

foundtr:
			;Get current CPU state
			ld iy,(#fcc0)			;Inter-SlotCall
			ld ix,#0183			;BIOS CALL GETCPU
			call $1c		
			ld b,a
			ld a,(#0082)			;Get command line input 
			sub #30
		
			cp b				;Test mode
			jp nz,currcpu
				ld de,equalmode
				jp print	

			;Test if commandline input is 0,1,2
currcpu:		
			cp 0
			jp z,legitchar
			cp 1
			jp z,legitchar
			cp 2
			jp z,legitchar
		
			ld de,info 
			jp print
		
legitchar:
			or 128				;Update Turbo Led

			ld iy,(#fcc0)			;Inter-SlotCall
			ld ix,#0180			;BIOS CALL CHGCPU
			call $1c	
			ld de,newmode
print:
			ld c,9				;Print text with textpointer de
			call 5
			ret

;------------------------------------------------
info:
		db "Usage: CHGCPU 0 / CHGCPU 1 / CHGCPU 2",10,13,10,13
		db "0 = Z80 (ROM) Mode",10,13
		db "1 = R800 (ROM) Mode",10,13
		db "2 = R800 (DRAM) Mode",10,13,"$"

newmode:
		db "New CPU Mode Set",10,13,"$"
		
notr:
		db "No Turbo-r Found",10,13,"$"

equalmode:
		db "CPU already in this mode",10,13,"$"

nametag:
		dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
		db "(c)2014"
	
end
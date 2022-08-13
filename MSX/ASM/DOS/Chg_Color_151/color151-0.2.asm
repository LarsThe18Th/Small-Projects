; Change color 15,1,1 v0.2
; Changes color to 15,1,1 in DOS
;

	output color151.com
	
	defpage 0,100h
	page 0
	code @ 100h
	
	
	
					jp main					
					db "             "
					db "Color151 0.2 by "
					db "Lars The 18Th   "
					db "CINIC Systems   "
					db "2022 (c)        "
					db "                "
main:
					ld bc,3
					ld hl,colorchoice
					ld de,#f3e9
					ldir
					
					ld iy,(#fcc0)						;Inter-SlotCall 
					ld ix,#62						;BIOS CALL CHGCLR - Changes the screen colors
					call #1c
					ret

					
					db 0,0,0,0,"->"
colorchoice:				db 15,1,1						;Change these last 3 bytes to set your own colors
					







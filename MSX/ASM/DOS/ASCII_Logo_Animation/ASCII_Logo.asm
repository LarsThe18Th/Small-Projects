; ASCII Logo v0.4
; Show ASCII Logo
;

	output ASCIIlogo.com
	
	defpage 0,100h
	page 0
	code @ 100h
	
	
	
					jp main					
					db "             "
					db "ASCIILogo0.4 by "
					db "Lars The 18Th   "
					db "CINIC Systems   "
					db "2022 (c)        "
					db "                "
main:

					xor a
					ld (#fca9),a							;Set Cursor off while printing

					ld iy,(#fcc0)							;Inter-SlotCall 
					ld ix,#c3							;BIOS CALL CLS
					call #1c

					ld b,17
					ld hl,asciilogoend - 80						;Logo Pointer
					
nextrow:
					push bc
					ld bc,#ffff-79
					add hl,bc							;Sub 80

					
print:
					xor a								;Set ram pointer to #0000
					out (#99),a							;Set Vram Pointer Low Part
					ld a,0+64
					out (#99),a							;Set Vram Pointer Hi Part


					push hl
nextchar:

					ld a,(hl)							;Load Char from memory
					and a								;Is it Zero
					jr z,donewriting						;Yes jump to Donwriting
						out (#98),a						;No write next Char to VRAM
						inc hl
						jr nextchar

donewriting:
					ei
					ld	b,3
waiting:				halt
					djnz waiting

					pop hl
					pop bc
					djnz nextrow


					;Set cursor to Row 16
					ld a,#15
					ld (#f3dc),a
					ret


asciilogobegin:

					;	 00000000011111111112222222222333333333344444444445555555555666666666777777777778
					;	 12345678901234567890123456789012345678901234567890123456789012345678901234567890
					db	"_____.___.                           .__             ____                       "      
					db	"\__  |   |  ____   __ __ _______     |  |    ____   / ___\  ____                "
					db	" /   |   | /  _ \ |  |  \\_  __ \    |  |   /  _ \ / /_/  >/  _ \               "
					db	" \____   |(  <_> )|  |  / |  | \/    |  |__(  <_> )\___  /(  <_> )              "
					db	" / ______| \____/ |____/  |__|       |____/ \____//_____/  \____/               "
					db	" \/                                                                             "
					db	"                                                                                "
					db	"                                                                                "
					db	"                                                                                "
					db	"===============================================================                 "
					db	"                     Your Logo Here !                                           "
					db	"===============================================================                 "
					db	"                                                                                "
					db	"                                                                                "
					db	"                                                                                "
					db	"                                                                                "
					db	"                                                                                "
					db	"                                                                                "
asciilogoend:				db  0


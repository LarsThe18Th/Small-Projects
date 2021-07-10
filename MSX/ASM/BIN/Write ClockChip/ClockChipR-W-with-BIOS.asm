; This example writes 7 Nibbles to the clockchip
; with use of BIOS
; Bank 1 Nibble 2 - 8
; It can be used to store a savegame for Firehawk Thexde 2

	output WrClkBio.bin


	defpage 0
	defpage 1,#c000

	page 0

	code
	byte #fe
	word #c000
	word #c000+(::1)-1
	word start


	page 1
	code

start:
				di
				ld b,7
				ld hl,savedata
loop:
				ld a,#10				;Set bit 7,6,5,4 to 0001 Bank1
				or b					;Set Nibble
				ld c,a
				inc c
				
				ld a,(hl)				;Set Data to write
				
				ld ix,#01f9				;Set SubBIOS WRTCLK
				call #015f				;Sub BIOS Call	

				inc hl

				djnz loop
				ret

savedata:
				;db #03,#05,#0c,#03,#01,#0e,#00
				db #00,#0e,#01,#03,#0c,#05,#09





end					
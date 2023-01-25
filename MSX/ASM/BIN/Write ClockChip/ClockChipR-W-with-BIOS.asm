; This example writes 7 Nibbles to the clockchip (Backwards)
; with use of BIOS
; Bank 1 Registers 2 - 8
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
				ld a,#10				;Bank 01
				or b					;Set Register
				ld c,a
				inc c
				
				ld a,(hl)				;Set Data to write
				
				ld ix,#01f9				;Set SubBIOS WRTCLK
				call #015f				;Sub BIOS Call	
				
				;      |BL|Regis|
				;C = XX|54|32310|	(Block bits 5-4) and (Register Bits 3-0).
				;A = data to write.	(4 least significant bits) 


				inc hl

				djnz loop
				ret

savedata:
				db #00,#0e,#01,#03,#0c,#05,#09





end
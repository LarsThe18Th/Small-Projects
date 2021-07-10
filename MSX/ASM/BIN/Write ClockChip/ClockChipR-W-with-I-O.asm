; This example writes 7 Nibbles to the clockchip
; with use of I/O ports #b4 & #b5
; Bank 1 Nibble 2 - 8
; It can be used to store a savegame for Firehawk Thexde 2

	output WrClkIO.bin


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
				ld a,#0d
				out (#b4),a				;Select Nibble #0d,13
				in a,(#b5)				;Read Nibble 13
				and #0c					;Reset bits 0,1 to 00
				or 1
				out (#b5),a				;Select Bank 1


				ld b,7
				ld hl,savedata
loop:
				ld a,b
				inc a
				out (#b4),a				;Select nibble
				
				ld a,(hl)
				out (#b5),a
				inc hl

				djnz loop
				ret

savedata:
				;db #03,#05,#0c,#03,#01,#0e,#00
				db #00,#0e,#01,#03,#0c,#05,#09





end					
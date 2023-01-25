; This example writes 7 Nibbles to the clockchip (Backwards)
; with use of I/O ports #b4 & #b5
; Block 1 Registers 2 - 8
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
				;Port #B4 select register (0-15) (Register 13 = Block to select [Bits 0,1])
				;Port #B5 Read/Write selected register. (Bits 4-7 are not used) 
				
				di
				ld a,#0d
				out (#b4),a				;Select Register 13 
				in a,(#b5)				;Read Register 13
				and #0c					;Reset bits 0,1 to 0 (Bits 2,3 have been preserved)
				or 1					;Select Block 1
				out (#b5),a				;Write Blocknumber to register 13


				ld b,7
				ld hl,savedata
loop:
				ld a,b
				inc a
				out (#b4),a				;Select Register
				
				ld a,(hl)
				out (#b5),a				;Write to Select Register
				inc hl

				djnz loop
				ret

savedata:
				db #00,#0e,#01,#03,#0c,#05,#09





end
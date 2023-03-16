	output boot.bin


	defpage 0
	defpage 1,$c000

	page 0

	code
	byte $FE
	word $c000
	word $c000+(::1)-1
	word begin

	page 1
	code


begin:
						xor a
						call #c3						;CLS BIOS Call: Clears the screen
						call #cc						;ERAFNK BIOS Call: Erase functionkey display


						;Load all Character in VRAM
						ld bc,charsend-chars			;Block Length
						ld de,#0c00						;Start of VRAM
						ld hl,chars						;Start of RAM
						call #5c						;LDIRVM BIOS Call :Block transfer From Memory to VRAM


						;Loop Copy 19x
						ld b,19							;Loop 19x
						ld de,#03c0						;Base Adress
loop
							ld hl,#ffd8
							add hl,de					;Add #28 With Use Of Carrier
							ex de,hl
							push bc
							push de


							ld bc,chars-table			;Block Length
							;ld de,VARIABEL				;Start of VRAM
							ld hl,table					;Start of RAM
							call #5c					;LDIRVM BIOS Call :Block transfer From Memory to VRAM
							pop de
							pop bc

							ei
							ld a,255
delay:								halt
									halt
							jp nz,delay

						djnz loop
						
						;Show message
						ld bc,msgend-msg			;Block Length
						ld de,#0230					;Start of VRAM
						ld hl,msg					;Start of RAM 
						call #5c					;LDIRVM BIOS Call :Block transfer From Memory to VRAM
						ret

table:
						db #80,#80,#80,#80,#80,#80,#81,#82,#82,#83,#80,#84,#82,#82,#85,#80,#86,#87,#88,#82,#82,#82,#82,#82,#82,#82,#89,#8A,#80,#8B,#8C,#82,#82,#8D,#80,#80,#80,#80,#80,#80
						db #80,#80,#80,#80,#80,#80,#8E,#8F,#8F,#90,#91,#92,#8F,#8F,#93,#8B,#94,#8F,#8F,#8F,#8F,#8F,#8F,#8F,#8F,#8F,#8F,#95,#96,#97,#8F,#8F,#98,#80,#80,#80,#80,#80,#80,#80
						db #80,#80,#80,#80,#80,#80,#99,#8F,#8F,#8F,#9A,#9B,#8F,#8F,#8F,#9C,#8F,#8F,#9D,#9E,#9F,#9F,#9F,#9F,#9F,#A0,#A1,#8F,#A2,#8F,#8F,#A3,#80,#80,#80,#80,#80,#80,#80,#80
						db #80,#80,#80,#80,#80,#A4,#A5,#8F,#8F,#8F,#A6,#8F,#8F,#8F,#8F,#A7,#A8,#8F,#8F,#8F,#8F,#8F,#A9,#AA,#80,#80,#AB,#AC,#8F,#8F,#AD,#AE,#80,#80,#80,#80,#80,#80,#80,#80
						db #80,#80,#80,#80,#80,#AF,#8F,#8F,#B0,#8F,#8F,#8F,#B1,#B2,#8F,#B3,#B4,#B5,#AC,#8F,#8F,#8F,#8F,#8F,#B6,#80,#B7,#8F,#8F,#8F,#B8,#B9,#80,#80,#80,#80,#80,#80,#80,#80
						db #80,#80,#80,#80,#80,#BA,#8F,#BB,#BC,#8F,#8F,#8F,#BD,#BE,#8F,#8F,#BF,#C0,#C0,#C0,#C0,#C1,#8F,#8F,#C2,#C3,#C4,#8F,#C5,#AC,#8F,#C6,#C7,#80,#80,#80,#80,#80,#80,#80
						db #80,#80,#80,#80,#8B,#C8,#8F,#C9,#80,#CA,#8F,#8F,#CB,#CC,#8F,#8F,#8F,#8F,#8F,#8F,#8F,#8F,#8F,#8F,#CD,#A5,#8F,#CE,#CF,#D0,#8F,#8F,#D1,#D2,#80,#80,#80,#80,#80,#80
						db #80,#80,#80,#80,#D3,#D4,#D4,#D5,#80,#D6,#D4,#D4,#D7,#80,#D8,#D4,#D4,#D4,#D4,#D4,#D4,#D4,#D9,#DA,#DB,#D4,#DC,#DD,#80,#80,#DE,#D4,#D4,#DF,#80,#80,#80,#80,#80,#80
						db #80,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00

chars:
						db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#04,#04,#04,#00,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#00,#F0,#F0,#F0,#F0,#F8,#F8,#F8,#00,#04,#04,#04,#04,#0C,#0C,#0C
						db #00,#E0,#E0,#E0,#E0,#F0,#F0,#F0,#00,#00,#00,#00,#00,#04,#0C,#1C,#00,#00,#0C,#3C,#FC,#FC,#FC,#FC,#00,#7C,#FC,#FC,#FC,#FC,#FC,#FC,#00,#F8,#FC,#FC,#FC,#FC,#FC,#FC
						db #00,#00,#00,#80,#80,#C0,#E0,#E0,#00,#00,#00,#00,#00,#00,#00,#04,#00,#1C,#3C,#3C,#7C,#FC,#FC,#FC,#00,#F0,#E0,#E0,#C0,#80,#80,#00,#04,#0C,#0C,#0C,#0C,#1C,#1C,#1C
						db #FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#F8,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#00,#00,#00,#00,#00,#80,#80,#80,#0C,#1C,#1C,#1C,#1C,#3C,#3C,#3C,#F0,#F8,#F8,#F8,#F8,#FC,#FC,#FC
						db #3C,#3C,#7C,#7C,#FC,#FC,#FC,#FC,#F0,#F8,#FC,#FC,#FC,#FC,#FC,#FC,#00,#00,#00,#00,#80,#C0,#C0,#E0,#0C,#0C,#1C,#3C,#3C,#7C,#FC,#FC,#F8,#F8,#F0,#E0,#E0,#C0,#80,#80
						db #1C,#3C,#3C,#3C,#3C,#3C,#7C,#7C,#80,#C0,#C0,#C0,#C0,#C0,#E0,#E0,#3C,#7C,#7C,#7C,#7C,#7C,#FC,#FC,#04,#84,#84,#84,#84,#84,#C4,#C4,#FC,#FC,#F8,#F0,#F0,#F0,#F8,#FC
						db #FC,#80,#00,#00,#00,#00,#00,#80,#FC,#00,#00,#00,#00,#00,#00,#00,#FC,#0C,#0C,#04,#00,#00,#00,#00,#FC,#FC,#FC,#FC,#FC,#FC,#7C,#3C,#F4,#FC,#FC,#FC,#FC,#FC,#FC,#FC
						db #FC,#F8,#F8,#F0,#E0,#E0,#C0,#80,#00,#00,#00,#00,#00,#00,#04,#04,#7C,#7C,#FC,#FC,#FC,#FC,#FC,#FC,#E0,#E0,#F4,#F4,#F4,#F4,#FC,#FC,#C4,#C4,#E0,#E0,#E0,#E0,#F0,#F0
						db #FC,#FC,#FC,#FC,#FC,#7C,#7C,#3C,#80,#F0,#FC,#FC,#FC,#FC,#FC,#FC,#00,#00,#00,#C0,#E0,#F0,#F8,#FC,#3C,#1C,#0C,#0C,#04,#00,#00,#00,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#7C
						db #FC,#FC,#F8,#F8,#F0,#E0,#E0,#C0,#80,#00,#00,#00,#00,#00,#00,#00,#04,#04,#0C,#0C,#0C,#0C,#1C,#1C,#FC,#FC,#DC,#DC,#DC,#DC,#8C,#8C,#FC,#FC,#FC,#FC,#FC,#FC,#F8,#F8
						db #FC,#FC,#7C,#7C,#7C,#7C,#3C,#3C,#F0,#F0,#F8,#F8,#F8,#F8,#FC,#FC,#3C,#1C,#0C,#04,#00,#00,#00,#00,#FC,#FC,#FC,#FC,#FC,#3C,#0C,#00,#00,#80,#80,#C0,#C0,#C0,#E0,#E0
						db #00,#04,#04,#0C,#1C,#1C,#3C,#7C,#E0,#F0,#F0,#F8,#FC,#FC,#FC,#FC,#00,#00,#00,#00,#00,#00,#80,#C0,#1C,#1C,#3C,#3C,#3C,#3C,#3C,#7C,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#F8
						db #8C,#8C,#04,#04,#04,#04,#04,#00,#F8,#F8,#F0,#F0,#F0,#F0,#F0,#E0,#3C,#3C,#1C,#1C,#1C,#1C,#1C,#0C,#00,#00,#80,#80,#80,#80,#80,#FC,#00,#00,#00,#00,#00,#00,#00,#FC
						db #7C,#1C,#0C,#0C,#0C,#1C,#7C,#FC,#E0,#E0,#E0,#E0,#E0,#E0,#E0,#E0,#00,#00,#04,#04,#0C,#1C,#1C,#3C,#7C,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#F4,#F0,#E0
						db #E0,#E0,#F0,#F8,#F8,#FC,#FC,#FC,#00,#00,#00,#00,#00,#00,#80,#80,#7C,#7C,#7C,#FC,#FC,#FC,#FC,#FC,#F8,#F8,#F8,#F0,#F0,#F0,#F0,#E0,#FC,#FC,#FC,#7C,#7C,#7C,#7C,#3C
						db #E0,#E0,#E0,#C0,#C0,#C0,#C0,#80,#0C,#0C,#0C,#04,#04,#04,#04,#00,#E0,#C0,#C0,#C4,#84,#8C,#1C,#1C,#FC,#FC,#FC,#FC,#FC,#F8,#F0,#F0,#C0,#C0,#80,#00,#00,#00,#00,#00
						db #7C,#3C,#1C,#1C,#0C,#04,#00,#00,#C0,#E0,#E0,#F0,#F8,#FC,#FC,#FC,#00,#00,#00,#00,#00,#00,#00,#80,#04,#04,#04,#0C,#0C,#0C,#0C,#00,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#00
						db #E0,#E0,#E0,#C0,#C0,#C0,#C0,#00,#3C,#3C,#3C,#1C,#1C,#1C,#1C,#00,#80,#80,#80,#00,#00,#00,#00,#00,#FC,#FC,#FC,#7C,#7C,#7C,#7C,#00,#FC,#FC,#FC,#FC,#FC,#F0,#80,#00
						db #F8,#F0,#E0,#C0,#04,#04,#0C,#00,#3C,#7C,#7C,#FC,#FC,#FC,#FC,#00,#FC,#FC,#FC,#FC,#FC,#FC,#F8,#00,#E0,#C0,#C0,#80,#00,#00,#00,#00,#7C,#3C,#3C,#1C,#0C,#0C,#04,#00
						db #C0,#C0,#E0,#F0,#F0,#F8,#FC,#00
charsend:


msg:					db "          Video RAM: 16Kbytes           "
						db "          User  RAM: 64Kbytes"
msgend:







						end

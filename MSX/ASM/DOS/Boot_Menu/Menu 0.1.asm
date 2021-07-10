; Menu.com v0.1

		output menu.com

		defpage 0,100h
		page 0
		code @ 100h


				jr begin
nametag:
				db "Menu 0.1      "
				db "(c)2020 by      "
				dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
				db "                  "

begin:
				;Clear F-keys
				xor a
				ld bc, #a0
				ld hl, #f87f
				ld de, #f880
				ld (hl),a
				ldir


				ld de,menutxt
				ld c,9								;Print menu TXT
				call 5


				ld hl,#fbf0							;Reset Keyboard Buffer
				ld (#f3fa),hl
				ld (#f3f8),hl


readfkeys:
				;Read F-Keys loop
					ld iy,(#fcc0)					;Inter-SlotCall 
					ld a,6							;Row 6
					ld ix,#0141						;BIOS CALL GetKey
					call #1c

					cpl
					or a
					jr z,readfkeys					;if #ff no key pressed

				and %11100000
				rlca
				rlca
				rlca
				jr z,readfkeys						;return if zero
				
				
				cp 1								;Is it F1
				jr nz,menu2
					ld bc, prg1

menu2:			cp 2								;Is it F2
				jr nz,menu3
					ld bc, prg2
	
menu3:			cp 4								;Is it F3
				jr nz,writekb
					ld bc, prg3


writekb:
				di
				ld hl,($f3f8)						;Read keyboard buffer write pointer
				ld ($f3fa),hl						;Clear Keyboard Buffer

loop:
				ld a,(bc)							;Put text from BC in keyboardbuffer
				or a
				jr z,sendbuff						;Until 0 is detected
					ld (hl),a
					inc hl							;Increase pointer keyboardbuffer
					inc bc							;Increase pointer BC text string
				jr loop

sendbuff:
				ld    ($f3f8),hl					;Write keyboardbuffer
				ei

ending:
				ret


; Load strings ----------------------------------------------------------

menutxt:
				db 12
				db "[F1] File manager",10,13
				db "[F2] Multi-Mente",10,13
				db "[F3] Sofarun",10,13,10,13
				;db 219,219,219,219,219,219,127,
				db "$" 

prg1:
				db "M",13,0
prg2:
				db "MM",13,0
prg3:
				db "SR",13,0
end

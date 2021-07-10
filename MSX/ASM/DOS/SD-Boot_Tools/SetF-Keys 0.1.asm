; SetFKeys.com v0.1
; -  Set F-Keys to 
;    opfxsd
;    _system		+ CHR$(13)
;    basic		+ CHR$(13)
;    dir/w		+ CHR$(13)
;    mm			+ CHR$(13)
;    color 15,0,0	+ CHR$(13)
;    speedon  		+ CHR$(13)
;    speedoff  		+ CHR$(13)
;    

	output setfkeys.com
	
	defpage 0,100h
	page 0
	code @ 100h


				jr begin
nametag:
				db "Set FKeys 0.1 "
				db "(c)2016 by      "
				dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
				db "                  "

begin:
				di
				ld b,0xa0							;160 Chars
				ld hl,fkeys							;Load F-keys pointer 
				ld de,0xf87f							;Pointer to F-Keys in memory
looop:
					ld a,(hl)
					cp 0xff
					jp z,blanck
					ld (de),a
blanck:
					inc hl
					inc de
				djnz looop
				ei
				
				ld iy,(#fcc0)							;Inter-SlotCall 
				ld ix,#cf							;BIOS CALL DiSPplay FuNction Keys
				call #1c
				ret

;------------------------------------------------

fkeys:
				;  "----------------"	
				db "opfxsd ",0,0,0,0,0,0,0,0,0						;Key - 1
				db "_system",13,0,0,0,0,0,0,0,0						;Key - 2
				db "basic",13,0,0,0,0,0,0,0,0,0,0					;Key - 3
				db "dir/w",13,0,0,0,0,0,0,0,0,0,0					;Key - 4
				db "mm",13,0,0,0,0,0,0,0,0,0,0,0,0,0					;Key - 5
				db "color15,0,0",13,0,0,0,0						;Key - 6
				db "speedon",13,0,0,0,0,0,0,0,0						;Key - 7
				db "speedoff",13,0,0,0,0,0,0,0						;Key - 8
				db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff	;Key - 9
				db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff	;Key - 10
	end

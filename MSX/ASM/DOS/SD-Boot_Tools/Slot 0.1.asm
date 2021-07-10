; Slot.com v0.1

		output slot.com

		defpage 0,100h
		page 0
		code @ 100h


				jr begin
nametag:
				db "Slot 0.1      "
				db "(c)2016 by      "
				dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
				db "                  "

begin:
				ld hl,#fbf0						;Reset Keyboard Buffer
				ld (#f3fa),hl
				ld (#f3f8),hl

				ld a,(#f348)
				dec a
				and 3

				or a							; Is 0 ?
				jr nz,slot2
					ld bc,batmsx1	
					jr writekb
slot2:
				cp 1							; Is 1 ?
				jr nz,notfound
					ld bc,batmsx2
					jr writekb

notfound:
				jr ending

writekb:
				di
				ld hl,($f3f8)						;Read keyboard buffer write pointer
				ld ($f3fa),hl						;Clear Keyboard Buffer

loop:
				ld a,(bc)						;Put text from BC in keyboardbuffer
				or a
				jr z,sendbuff						;Until 0 is detected

				ld (hl),a
				inc hl							;Increase pointer keyboardbuffer
				inc bc							;Increase pointer BC text string
				jr loop

sendbuff:
				ei
				ld    ($f3f8),hl					;Write keyboardbuffer
ending:
				ret


; Load strings ---------------------------------------------------------
batmsx1:
		db "1",13,0
batmsx2:
		db "2",13,0

end

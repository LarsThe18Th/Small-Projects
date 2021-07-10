; Setfkeys.com v0.1

		output setfkeys.com

		defpage 0,100h
		page 0
		code @ 100h


				jr begin
nametag:
				db "SetFkeys 0.1  "
				db "(c)2020 by      "
				dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
				db "                  "

begin:

				;Restore function keys
				ld iy,(#fcc0)						;Inter-SlotCall 
				ld ix,#3e							;BIOS CALL Restore Fkeys
				call #1c

ending:
				ret

end

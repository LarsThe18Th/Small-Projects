; First.com v0.1
; -  Set Some screen Options
;    color 15,0,0
;    Screen 0
;    width 80
;    60Hz
;    KeyClick Off
;

	output first.com

	defpage 0,100h
	page 0
	code @ 100h


				jr begin
nametag:			db "BootFirst 0.1 "
				db "(c)2016 by      "
				dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
				db "                  "

begin:
				; Screen 80 / Width 80 ---------------------------------
				ld a,80								;Width 40
				ld (#f3ae),a							;Write screen width
				ld ix,#006c							;Switch to screen 0 BIOS Call
				ld iy,(#fcc0)							;Load BIOS location
				call #1c							;Inter SLotcall

				; Change Colors ----------------------------------------
				ld a,#0f							; Colors
				ld (#f3e9),a							; Forground White
				xor a
				ld (#f3ea),a							; Background Black
				ld (#f3eb),a							; Border Black
				ld iy,(#fcc0)							;Inter-SlotCall 
				ld ix,#62							;BIOS CALL CHanGe CoLoR
				call #1c

				; 60 Hz ------------------------------------------------
				ld a,(#ffe8)							;Read register 9
				res 1,a								;Reset Bit 1 (NTSC)
				di
				ld (#ffe8),a							;Store new setting
				out	(#99),a							;Write to VDP R#9
				ld	A,9+128
				out	(#99),a
				ei
				; Key Click Off------------------------------------------
				xor a
				ld (#f3db),a
				ret
end

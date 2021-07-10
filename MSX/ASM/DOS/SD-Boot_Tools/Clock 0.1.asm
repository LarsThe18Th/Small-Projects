; Clock.com v0.1
; -  Set Clockchip settings
;

	output clock.com

	defpage 0,100h
	page 0
	code @ 100h


				jr begin
nametag:
				db "Clock 0.1     "
				db "(c)2016 by      "
				dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
				db "                  "

begin:
				di
				ld c,2
				ld hl,block2
				call setblock				
				ld c,3
				ld hl,block3				
				call setblock
	
				; Write (0,0) to Display Adjust Register #18
				xor a
				out (#99),a
				ld a,18+128
				out (#99),a
				ei
				ret
				

;---------------------------------------------------------------------
; --- SUB Select Block - BlockNr in C = 0,1,2,3
; --- SUB Write array to ClockChip

setblock:
				ld a,#0d
				out (#b4),a				;Select Nibble #0d,13
				in a,(#b5)				;Read Nibble 13
				and #0c					;Reset bits 0,1 to 00
				or c
				out (#b5),a				;Select Block 2
				

writeclk:
				ld b,13
looop:
					ld a,b
					dec a
					out (#b4),a			;Select nibble
					ld a,(hl)
					cp #ff
					jr z,skip
						out (#b5),a
skip:
					inc hl
				djnz looop
				ret


; ---------------------------------------------------------------------
;			db #ff,#00,#00,#ff,#00,#05,#0f,#00,#00,#01,#03,#ff,#ff
;		  OpenMSX = 26--25--24--23--22--21--20--1F--1E--1D--1C--1B--1A
block2:			db #ff,#ff,#03,#01,#00,#00,#0f,#05,#00,#ff,#00,#00,#ff

;			db #02,#06,#04,#09,#06,#0c,#06,#05,#06,#03,#07,#00,#00
;		  OpenMSX = 33--32--31--30--2F--2E--2D--2C--2B--2A--29--28--27
block3:			db #00,#00,#07,#03,#06,#05,#06,#0c,#06,#09,#04,#06,#02


end

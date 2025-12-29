; MSX1 Pallet 0.1

; Loads ExecROM Enhanced color Pallette 

	output MSX1pal.com
	
	defpage 0,100h
	page 0
	code @ 100h




					jr begin
nametag:
					dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
					db "(c)2014 / 2025  "

begin:				xor a
					ld hl,palette						; Pointer to palette adress
					di
					out (#99),a
					ld a,16+128							; Write register #16+128
					ei									; Color palette adress register
					out (#99),a
					ld c,#9a							; Out (#9A)

					dw #A3ED,#A3ED,#A3ED,#A3ED   		; 32x OUTI instruction
					dw #A3ED,#A3ED,#A3ED,#A3ED   		; (faster than OTIR)
					dw #A3ED,#A3ED,#A3ED,#A3ED
					dw #A3ED,#A3ED,#A3ED,#A3ED
					dw #A3ED,#A3ED,#A3ED,#A3ED
					dw #A3ED,#A3ED,#A3ED,#A3ED
					dw #A3ED,#A3ED,#A3ED,#A3ED
					dw #A3ED,#A3ED,#A3ED,#A3ED
					
					ret

palette:
		db #00,#00,#00,#00,#23,#05,#34,#06
		db #15,#02,#26,#03,#51,#02,#37,#05
		db #62,#03,#72,#04,#72,#06,#74,#07
		db #12,#04,#54,#02,#55,#05,#77,#07


end
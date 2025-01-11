; MSX1 0.1

; Set screen 0 Width 40
; Detect Turbo-r and set it to Z80 Mode
; Set VDP to 50Hz
; Loads MSX1 color Pallette 

	output MSX1.com
	
	defpage 0,100h
	page 0
	code @ 100h




					ld a,40								; Width 40
					ld (#f3ae),a						; Write screen width
					
					ld ix,#006c							; Switch to screen 0 BIOS Call
					ld iy,(#fcc0)						; Load BIOS location
					call #1c							; Inter SLotcall
					
					xor a								; Slot 0 not expanded
					ld hl,#2d							; Adress to read
					ld ix,#0c							; Read adres in other slot BIOS Call
					ld iy,(#fcc0)						; Load BIOS location
					call #1c							; Inter SLotcall
					sub 03								; Test if Turbo-r
					jp nz,noturbor
					
					ld a,#80							; CPU mode Z80
					ld ix,#180							; Change CPU mode BIOS Call
					ld iy,(#fcc0)						; Load BIOS location
					call #1c							; Inter SLotcall

noturbor:
					ld a,(#ffe8)						; Read VDP Register #9
					set 1,a								; Set bit 1 (50HZ)
					ld (#ffe8),a						; Write VDP Register #9

					out (#99),a							; Value to write to VDP
					ld a,#89							; Select VDP Register #9+128
					out (#99),a							; Write 

					xor a
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
		db #00,#00,#00,#00,#33,#06,#44,#07
		db #36,#03,#47,#04,#62,#02,#47,#07
		db #73,#03,#74,#04,#62,#05,#63,#06
		db #11,#05,#66,#03,#66,#06,#77,#07
						
nametag:
		dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
		db "(c)2014 / (c)2025"

end
;----------------------------------------------
; B-Boot v0.1
; Set B dirve active in Cartridge
; #f247
;----------------------------------------------
	
	; Output
	output bboot01.rom
	defpage 1,4000h,20000h
	;defpage 2,8000h,*
	page 1;,2


	
				db #41,#42,#10,#40,0,0,0,0,0,0,0,0,0,0,0,0

				
begin:
				ld a,1
				ld (#f247),a
				
				; Copy ISR routine
				ld bc,isrend-isrbegin
				ld hl,isrbegin
				ld de,#e000
				ldir
				
				; Initialize ISR
				ld bc,3
				ld hl,isrinit
				ld de,#fd9a
				ldir
				ret


isrinit:
				call #e000

				


isrbegin:
				ld a,(#f247)
				and a
				ret nz
					di
					ld a,1
					ld (#f247),a
					
					; Restore ISR 
					ld hl,#fd9a
					ld (hl),#c9
					inc hl 
					ld (hl),#c9
					inc hl 
					ld (hl),#c9
					inc hl
					ei
					ret
					
isrend:








; Sc3ani.com v0.3
; -  Screen 3 Animation
; -  Included Compression
;
	output sc3ani.com

	defpage 0,100h
	page 0
	code @ 100h


				jr begin
nametag:
				db "Sc3Ani 0.3    "
				db "(c)2016 by      "
				dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
				db "                  "

begin:
				;Set Screen 3 by BIOS
				ld hl,sc3set
				ld de,#f3d1
				ld bc,10
				ldir 

				ld ix,#0075							;Switch to screen 3 BIOS Call
				ld iy,(#fcc0)						;Load BIOS location
				call #1c							;Inter SLotcall

				;Set border Color
				di
				ld a,15
				out (#99),a
				ld a,7+128
				out (#99),a

				;Set Pallette
				xor	a								;Set p#pointer to zero.
				ld hl,palet
				out	(#99),a
				ld	a,16+128
				out	(#99),a
				ld	bc,#209A						;out 32x to port #9A
				otir
		
				;Load frames 0 to 7 to VRAM
				xor a								;Set ram pointer to #0800
				out (#99),a							;Set Vram Pointer Low Part
				ld a,08+64
				out (#99),a							;Set Vram Pointer Hi Part

				ld hl,allframes
				ld e,(hl)
				inc hl
				ld d,(hl)
				inc hl

nextblock:
				;Check if Reg #14 must be set
				push hl
				ld hl,(frametemp)
				dec hl
				ld (frametemp),hl
				ld a,l
				or h
				jr nz,lastframe
					ld a,1
					out (#99),a
					ld a,14+128
					out (#99),a
lastframe:
				pop hl

				;Check if all writes are done
				dec de
				ld a,e
				or d
				jr z,writedone

				ld a,(hl)
				inc hl
				cp (hl)
				jr z,equal
					out (#98),a
					jr nextblock

equal:
				inc hl
				ld b,(hl)
multi:
					out (#98),a
				djnz multi

				inc hl
				jr nextblock

writedone:
				ei
				ld b,1								;Select active Frame
whait:
				ld a,(#fc9e)						;Read Jiffy
				sub 07								;If 7 interupts passed
				jr c,noframe
					ld a,b
					cp 9							;Check if this is the last frame
					jr nz,reset
						ld b,1						;Set first frame

reset:
					xor a							;Reset Jiffy
					ld (#fc9e),a

					di
					ld a,b
					out (#99),a
					ld a,4+128
					out (#99),a						;Next Frame
					inc b
					ei

noframe:
				;Whait for Space Key
				in	a,(#aa)
				and	#f0								;only change bits 0-3
				or	8								;take row number
				out	(#aa),a
				in	a,(#a9)							;read row into A
				inc a
				jr z,whait

				;Restore Pallette
				di
				xor	a								;Set p#pointer to zero.
				ld hl,paletorg
				out	(#99),a
				ld	a,16+128
				ei
				out	(#99),a
				ld	bc,#209A						;out 32x to port #9A
				otir

				;Back to Screen 0
				ld ix,#006c							;Switch to screen 0 BIOS Call
				ld iy,(#fcc0)						;Load BIOS location
				call #1c							;Inter SLotcall
				
				;Clear Keyboard Buffer
				di
				ld hl,($f3f8)						;Read keyboard buffer write pointer
				ld ($f3fa),hl						;Clear Keyboard Buffer
				ei
				ret


;---------------------------------------------------------------------
sc3set;
				dw #0000, #09c0, #0800, #1600, #0000
palet:
				db #00,#00,#00,#00,#00,#00,#21,#01,#31,#02,#22,#02,#32,#02,#41,#01
				db #41,#03,#43,#03,#61,#01,#44,#03,#61,#05,#44,#04,#55,#05,#77,#07
paletorg:
				db #00,#00,#00,#00,#11,#06,#33,#07,#17,#01,#27,#03,#51,#01,#27,#06
				db #71,#01,#73,#03,#61,#06,#64,#06,#11,#04,#65,#02,#55,#05,#77,#07
frametemp:
				dw #0ae4
allframes:
				incbin Frames_C.bin








end

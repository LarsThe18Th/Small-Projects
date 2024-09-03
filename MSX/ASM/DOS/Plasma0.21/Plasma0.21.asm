; SC0Plasma v0.21
; Plasma Effect with ASCII in TXT Mode 0
;
; Original idea and code example by:
; Goblinish (Krapivin Dmitry)


	output pl021.com

	defpage 0,#0100
	page 0

	code

vdpio  equ #99				; VDP IO (Read from BIOS Adress #0007	
sinpl  equ #7F00
charpl equ sinpl+256



					jp main
					db "             "
					db "Plasma 0.21 by  "
					db "Lars The 18Th   "
					db "CINIC Systems   "
					db "(c)2024         "
					db "                "
main:

					; Delay - Wait for the disk drive to stop
					; ld b,128
delay:				; halt
					; djnz delay


					; di
					; ld hl,#0000						; TXTNAM set pattern name table address
					; ld (#f3b3),hl 

					; ld hl,#0800						; TXTCGP set Pattern generator table address
					; ld (#f3b7),hl


					; Read MSX version Number from BIOS
					xor a								; Slot 0
					ld hl,#002d
					call #0c							; RDSLT
					
					cp 3								; Is it Turbo-r
					; ----------------------
					push af
					jr nz,noturbor

						pop af
						call getcpu						; Read CPU Mode for backup
						set 6,a							; Set bit 6  (Remember Turbo-r)
						set 7,a							; Turn Turbo Led On/Off
						push af

						xor a
						set 7,a							; Turn Turbo Led On/Off
						call chgcpu						; Change CPU to Z80 (ROM) mode

noturbor:

					di
					; Backup Screenwidth
					ld a,(#f3ae)
					ld (bupsrcwidth),a

					; With 40
					ld a,40
					call setscr0

					; Set color 15,1
					ld a,#f1							; TXT color 15, Back color 1
					out (vdpio),a

					ld a,#87
					out (vdpio),a


					; Put all 5 Chars in VRAM
					ld b,5
					ld c,vdpio
					ld hl,charset
add_chars:
					push bc
					outi								; Set adress Low byte
					nop
					outi								; Set adress High byte
					nop

						ld b,8
						ld c,vdpio-1
setvdpregisters:
						outi
						jp nz,setvdpregisters			; Write to VRAM

					pop bc
					djnz add_chars


					; copy chars to place
					ld de,charpl
copch1:
					ld hl,plchar
copch2:
					ld a,(hl)
					inc hl
					or a
					jr z,copch1
					ld (de),a
					inc e
					jr nz,copch2


					; Generate Sinus
					ld bc,sinpl
					ld h,c
					ld l,c
					ld e,c
					ld d,c
genlp:
					add hl,de
					ld a,h
					ld (bc),a
					push bc

					ld a,b
					sub c
					ld c,a

					ld a,b
					sub h
					ld (bc),a
					pop bc

					ld a,e
					add a,8
					ld e,a
					jr nc,noincd
					inc d
noincd:
					inc c
					bit 6,c
					jr z,genlp

					ld d,b
					ld e,#80
					ld c,b
neglp:
					ld a,(bc)
					sra a
					ld (bc),a
					ld (de),a
					inc e
					dec c
					jr nz,neglp

					; Draw Plasma
plas_lp:
					; No need for slowdown
					; ei		
					; halt
					; di

					; keep Parameters
					push de
					push bc
					exx
					ld hl,pltxt
					push hl
					exx

					; db #dd							; #DD, 2E -> Undocumented instruction !
					; ld l,24							; ld ixl,n
					ld ixl,24							; May crash on zome Z80 CPU's

ply:
					ld a,40
					push de

plx:
					ex af,af'
					ld h,sinpl/256
					ld l,e
					ld a,(hl)
					ld l,d
					add a,(hl)
					ld l,c
					add a,(hl)
					ld l,b
					add a,(hl)

					ld l,a
					inc h
					ld a,(hl)

					exx
					ld (hl),a
					inc hl
					exx

					inc d
					inc e
					inc e
					inc e

					ex af,af'
					dec a
					jp nz,plx

					pop de

					inc e
					inc e
					dec d
					dec d
					dec d

					ld a,b
					add a,1
					ld b,a

					ld a,c
					add a,3
					ld c,a

					; db #dd							; #DD, 2D -> Undocumented instruction !
					; dec l								; dec ixl
					dec ixl								; May crash on zome Z80 CPU's
					jp nz,ply

					; Copy to Screen
					pop hl ; ld hl,pltxt

					xor a
					out (vdpio),a
					
					or #40
					out (vdpio),a						; Set V-Ram adress to #0000


					ld a,4
olp:
					ld b,0
					ld c,vdpio-1
					otir
					dec a
					jr nz,olp


					pop bc
					inc c
					inc b
					inc b
					pop de

					inc e
					inc d
					inc d

					; Keypressed
					in a,(#aa)							; Read Status
					and #f0         					; Filter bits 0-3
					or 8            					; Select Row 8
					out (#aa),a
					in a,(#a9)      					; Read row into A
					cpl									; → ↓ ↑ ← DEL INS HOME SPACE
					or a
					jp z,plas_lp

					; End & Clear Keyboard Buffer
					ei
					ld ix,#0156							; BIOS CALL KILBUF
					call intsltcll

					; Restore CPU Mode
					pop af
					bit 6,a								; Was it Turbo-r ?
					jp z,skiprestore
						res 6,a
						call chgcpu						; Restore CPU to Original mode

skiprestore:

					; Restore Secreenwidth and Init Screen 0
					ld a,(bupsrcwidth)
					ld (#f3ae),a 
					jr setscr0



					; Subroutines
chgcpu:
					ld ix,#180
					jr intsltcll

getcpu:
					ld ix,#183
					jr intsltcll

setscr0:
					ld (#f3ae),a 
					ld ix,#6c							; BIOS CALL INITXT
					;jr intsltcll

intsltcll:
					ld iy,(#fcc0)						; Inter-SlotCall 
					call #1c
					ret


					; Data
bupsrcwidth:
					db #00
plchar:
					db "..oo**OO00OO**oo.." 			; .o*O0O*o.
					db 0
pltxt:

; everything below will be overwritten in Memory by the Plasma Characters an Sinus data

charset:
; '.' charakter
					db #70,#09+64						;VRAM adress 0970
					db %00000000
					db %00000000
					db %00000000
					db %00000000
					db %00100000
					db %00000000
					db %00000000
					db %00000000

; 'o' charakter
					db #78,#0b+64						;VRAM adress 0b78
					db %00000000
					db %00000000
					db %00000000
					db %00110000
					db %00110000
					db %00000000
					db %00000000
					db %00000000

; '*' charakter
					db #50,#09+64						;VRAM adress 0950
					db %00000000
					db %00000000
					db %00110000
					db %01111000
					db %01111000
					db %00110000
					db %00000000
					db %00000000

; 'O' charakter
					db #78,#0a+64						;VRAM adress 0a78
					db %00000000
					db %00110000
					db %01111000
					db %11111100
					db %11111100
					db %01111000
					db %00110000
					db %00000000
					
; '0' charakter
					db #80,#09+64						;VRAM adress 0980
					db %01111000
					db %11111100
					db %11111100
					db %11111100
					db %11111100
					db %11111100
					db %01111000
					db %00000000










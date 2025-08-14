; CubeCRC
; Calculating CRC of a 64k ROM in Slot 1 or 2
; Lars The 18Th (c)2025




    output CUBECRC.com

    defpage 0,100h
    page 0
    code @ 100h


slotnr equ 2						; Change to 1 for Slot 1


			di
			ld de,nametag			; Show nametag
			ld c,9				; String Output Function
			call 5				; Call DOS Function
			
			; Copy first 32k from ROM to RAM #0000 -> #4000 (Backwards)
			ld hl,#7fff			; Adress to read
notdone:
			push bc
			ld a,slotnr
			call #0c			; Reads the value of an address in another slot
			pop bc

			push hl
			ld a,#40			; Calculate detination adress
			add a,h
			ld h,a
			ld (hl),e
			pop hl

			ld a,h				; Check if copying is finished
			or l
			dec hl
			jp nz,notdone


			call docrc			; Calculating CRC from the 1st 32k part


			; Copy second 32k from ROM to RAM (We need to do this in 2 steps of 16k
			; First 16k (#8000 -> #4000)
			in a,(#a8)
			push af
			ld a,slotnr			; Calculate and Set Page 2
			rlca
			rlca
			rlca
			rlca
			ld b,a
			pop af
			push af
			and #cf
			or b
			out (#a8),a

			ld bc,#4000			; Copy block
			ld de,#4000
			ld hl,#8000
			ldir
			pop af
			out (#a8),a			; Restore Slot Resgiter


			; Second 16k (#C000 -> #8000)
			push af
			ld a,slotnr			; Calculate and Set Page 3
			rrca
			rrca
			ld b,a
			pop af
			ld c,a				; Save Slot Resgiter in Reg C
			and #3f				; Because we have no Stack to POP from
			or b				; after switching Page 3

			out (#a8),a
			ld a,c
			ld bc,#4000
			ld de,#8000
			ld hl,#c000
			ldir
			out (#a8),a			; Restore Slot Resgiter


			call docrc			; Include CRC Calculation from the 2nd 32k part


			; Covert CRC (XoR #ff) to String and print Hex digits
			ld hl,crc+3
			ld b,4
hexloop:
				ld a,(hl)
				xor #ff
				push bc
				push hl
				call printhex
				pop hl
				pop bc
				dec hl
			djnz hexloop
			ret

; ---------------------------------------------------------------
; CRC Calculation Routine

docrc:

.crc32
			ld ix,#4000			; address
			ld bc,#8000			; count

			ld de,(crc)			; incoming crc
			ld hl,(crc+2)


bytelp:
			push bc				; save count
			ld a,(ix)			; fetch byte from memory


			xor e				; xor byte into crc bottom byte
			ld b,8				; prepare to rotate 8 bits

rotlp:
			srl h\ rr l\ rr d\ rra		; rotate crc
			jr nc,cleaned			; b0 was zero
			ld e,a							; put crc low byte back into e
			ld a,h\ xor #ed\ ld h,a		; crc=crc xor &edb88320, zip polynomic
			ld a,l\ xor #b8\ ld l,a
			ld a,d\ xor #83\ ld d,a
			ld a,e\ xor #20			; and get crc low byte back into a

cleaned:
			dec b\ jr nz,rotlp		; loop for 8 bits
			ld e,a				; put crc low byte back into e

			inc ix				; step to next byte
			pop bc\ dec bc			; num=num-1

			ld a,b\ or c\ jr nz,bytelp	; loop until num=0
			ld (crc),de\ ld (crc+2),hl	; store outgoing crc	
			ret

; ---------------------------------------------------------------
printhex:
			push af
			rlca
			rlca
			rlca
			rlca
			call printdigit			; Print Fist Hex Digit
				
			pop af
			call printdigit			; Print Second Hex Digit
			ret


printdigit:
			and $0F
			cp 10
			jr c,klein
				add a,55
				jr print
klein:
				add a,48
print:
			ld e,a
			ld c,2				; Console Output Function
			call 5				; Call DOS Function
			
			ret
; ------------------------------------------------------------

crc:			dw #ffff, #ffff
crcend:

			db 00
nametag:		db 10,13,"CubeCRC v0.1",10,13 
			db "By Lars The 18Th",10,13 
			db "(c) 2025",10,13,10,13
			db "CRC32 = $"













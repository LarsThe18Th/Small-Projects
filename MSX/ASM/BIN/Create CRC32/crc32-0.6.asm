; ---------------------------------------------------------------
; Create CRC32 of the Diskrom
; Last 8 Bytes are hashed as #FF
; ---------------------------------------------------------------

  output crc32-06.bin


	defpage 0
	defpage 1,#d000

	page 0

	code
	byte #fe
	word #d000
	word #d000+(::1)-1
	word start

	page 1
	code


start:
        		di
; Print msg

				ld hl,strmsg
prntmsg:
				ld a,(hl)
				or a
				jr z,done
					call #a2
					inc hl
					jr prntmsg

done:

				ld hl,#f39a
				ld de,#d000
				ld (hl),e
				inc hl
				ld (hl),d

				in a,(#a8)						;Backup current slot
				push af
				ld a,(#ffff)					;Backup current SUB slot
				cpl
				push af
				
				ld a,(#f348)					;Read DiskROM Slot Location
				ld h,%01000000					;Set page 1
				call #24

; ---------------------------------------------------------------
; Multiple passes over data in memory can be made to update the CRC.
; For ZIP, initial CRC must be &FFFFFFFF, and the final CRC must
; be EORed with &FFFFFFFF before being stored in the ZIP file.
; Total 70 bytes. 



.crc32
				ld ix,#4000						; address
				ld bc,#4000						; count

				ld de,(crc)						; incoming crc
				ld hl,(crc+2)

; enter here with ix=addr, bc=num, hlde=crc

bytelp:
				push bc							; save count
				ld a,(ix)						; fetch byte from memory


; the following code updates the crc with the byte in a
				xor e							; xor byte into crc bottom byte
				ld b,8							; prepare to rotate 8 bits

rotlp:
				srl h\ rr l\ rr d\ rra			; rotate crc
				jr nc,cleaned					; b0 was zero
				ld e,a							; put crc low byte back into e
				ld a,h\ xor #ed\ ld h,a			; crc=crc xor &edb88320, zip polynomic
				ld a,l\ xor #b8\ ld l,a			;
				ld a,d\ xor #83\ ld d,a			;
				ld a,e\ xor #20					; and get crc low byte back into a

cleaned:
				dec b\ jr nz,rotlp				; loop for 8 bits
				ld e,a							; put crc low byte back into e
; ---------------------------------------------------------------


				inc ix							; step to next byte
				pop bc\ dec bc					; num=num-1
				
				
				push bc
					ld a,b
					or a
					jp nz,notlastbytes
					
					ld a,c
					cp 8
					jp nz,notlastbytes
						ld ix,dskromregs

notlastbytes:
				pop bc
				
				ld a,b\ or c\ jr nz,bytelp		; loop until num=0
				ld (crc),de\ ld (crc+2),hl		; store outgoing crc

; Covert to String and print

				ld b,4
					ld hl,crc+3
hexloop:
					ld a,(hl)
					xor #ff
					call printhex
					dec hl
				djnz hexloop

				
				pop af
				ld (#ffff),a					;Restore current SUB slot
				pop af
				out (#a8),a						;Restore current slot 
				ei

; Reset results when using a=usr(0)------------------------------


				ld a,#ff				
				ld hl,crc
				ld (hl),a
				ld de,crc+1
				ld bc,3
				ldir

				ret


; ---------------------------------------------------------------
printhex:
				push af
				rlca
				rlca
				rlca
				rlca
				call printdigit					;Print Fist HEX Digit
				
				pop af
				call printdigit					;Print Second HEX Digit
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
				call #a2
				ret

; ---------------------------------------------------------------
strmsg:			db 10,13,"Calculating.",10,13,"CRC32 = #",0
crc:			dw #ffff, #ffff
crcend:

dskromregs:		db 255,255,255,255,255,255,255,255

nametag:		db "        "
				db "DSKROMCRC32 v0.6" 
				db "By Lars The 18Th" 
				db "(c)2021         "



end


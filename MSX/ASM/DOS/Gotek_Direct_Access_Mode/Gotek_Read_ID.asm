; Gotek Direct Access Mode
; Only for WD2793 Floppy Drive Controllers 
; (Used in e.g. Philips NMS 82xx MSX Computers)


    output gotek.com

    defpage 0,100h
    page 0
    code @ 100h


					di
					; Init FDC
	                in a,(#a8)							; Backup current Slot
	                push af
	                ld a,(#ffff)						; Backup current SUB Slot
	                cpl
	                push af

	                ld a,(#f348)						; Read DiskROM Slot Location
	                ld h,%01000000						; Set page 1
	                call #24

					; Set FDC controller values         ; Is drive BUSY, Read status bit 0
					ld a,#c4							; Drive A (Bit0), Motor on (Bit7)
					ld (#7ffd),a						; Set Drive


					; Drive Ready
					ld hl,#7ff8
drive_ready:
					bit 7,(hl)							; Read status register
					jr nz,drive_ready					; Drive ready ? (Bit 7 = 0 )


					; Set Track 255
					ld a,255
					ld (#7ffb),a						; Set destination TRACK in DATA Register

					; Seek command
	                ld a,#1c
	                ld (#7ff8),a						; Write SEEK command with Verify & Head in COMMAND REGISTER


					call fdc_cmd_done
				
					call fdc_drv_busy


					; Read Sector
					xor a
					ld (#7ffa),a						; Set Sector register to 0

					ld a,%10000000						; Read Sector command
					ld de,#9000							; Set Store Memmory adress
					ld hl,#7fff

					ld (#7ff8),a						; Set Read Sector Command
cmmd_done:
					bit 6,(hl)							; Is current command done ?
					jr z,read_done						; Jump if reading is done

					bit 7,(hl)	
					jp nz,cmmd_done						; Ready to read ?
				
					ld a,(#7ffb)						; Get read data from data register
					ld (de),a
					inc de
					jr cmmd_done						; Get next byte

read_done:

					ld a,(#7ff8)						; Save status resister
					ld c,a


					call fdc_drv_busy


					; Restore Track 0
					xor a								
					ld (#7ff8),a						; Set Restore Command


					call fdc_cmd_done


					; Restore Slots
					pop af
                	ld (#ffff),a						; Restore current SUB Slot
                	pop af
                	out (#a8),a							; Restore current Slot 

				
					ld de,default_msg					; Load default text

					ld a,c
					and a				
					jr nz,prnt_msg						; No rerror ? (0)


					; Prepare ID strings
					ld b,2
					ld hl,#9000
					ld de,drive_id

read_next:
					ld a,(hl)
					and a	
					jr z,zero_term
					ld (de),a
					inc hl
					inc de
					jr read_next

zero_term:
					inc hl
					ld de,soft_ver
					djnz read_next

					ld de,id_string


					; Printing results
prnt_msg:

					ld c,9								; Print String to screen
					call 5

					ei
					ret

; -----------------------------------------------------------------------

fdc_cmd_done:
					ld hl,#7fff
not_done:
					bit 6,(hl)
					jr nz,not_done						; Wait until current command is done
					ret


fdc_drv_busy:
					ld hl,#7ff8
drv_busy:
					bit 0,(hl)							; Read status register
					jr nz,drv_busy						; Drive busy ? (Bit 0 = 0 )
					ret

; -----------------------------------------------------------------------

default_msg:	db "No Gotek Found",10,13,"$"
id_string:		db 10,13
				db "ID:  "
drive_id:		db "        "
				db 10,13
				db "Ver: "
soft_ver:		db "            "
				db 10,13,"$"
end_default_msg:







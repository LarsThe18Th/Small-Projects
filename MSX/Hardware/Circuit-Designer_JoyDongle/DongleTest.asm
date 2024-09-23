;----------------------------------------------
; Circuit-Designer Dongel test tool
;
; (dongle in Port 2)
;----------------------------------------------

	output test.bin


	defpage 0
	defpage 1,#9000

	page 0

	code
	db #fe
	dw #9000
	dw #9000+(::1)-1
	dw start

	page 1
	code

start:
								call #cc					; Disable Function Keys
								xor a
								call #c3
								xor a						; Set ram pointer to #0000
								out (#99),a					; Set Vram Pointer Low Part
								ld a,0+64
								out (#99),a					; Set Vram Pointer Hi Part



								ld b,4						; Loop 4 times
								ld hl,pinout				; Read port values
outerloop:
								ld c,(hl)

								call setport
								inc hl

								; Pause
								ld de,#ffff
innerloop:						
								dec de
								ld a,d
								or e
								jr nz,innerloop

								djnz outerloop
								jr start


setport:
								; Write port
								di
								ld a,#0f					; Select register Port 15
								out (#a0),a
								ld a,c
								out (#a1),a					; Set Pin 6 & 7 + Select Joystick port 2 for read

								; Read port
								ld a,#0e
								out (#a0),a					; Select register Port 14
								in a,(#a2)					; Read Joystick port 2
								and 1						; Only need UP status (Pin1)
								or #30
								out (#98),a					; Write result to VRAM 
								ret


pinout:				db #43,#47,#4b,#4f


end
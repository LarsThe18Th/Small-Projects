   ;recalibrate Dive A & B 
	
	output DiskX 0.2.rom
	defpage 1,4000h,8000h
	page 1
	
	org #7861	
	
	PUSH	BC
	PUSH	DE
	PUSH	AF
	CALL	#5FC2				; GETWRK


	;Drive A

	LD	A,0C4H
	LD	(#7FFD),A			; motor on, in use, set b2, select drive 0
	RES	5,D
	CALL	#7835				; seek to 5 cylinders futher
	CALL	#781B				; seek to cylinder 0
	
	CALL	#78B4				; recalibrate two times
	CALL	#780E				; wait 18 ms (head settle)
		
	
	;One Drive ?
	POP	AF
	PUSH	AF
	JR	Z,onedrive			; CTRL pressed, skip drive B check


	;Drive B

	LD	A,0C5H
	LD	(#7FFD),A			; motor on, in use, set b2, select drive 1
	RES	5,D
	CALL	#7835				; seek to 5 cylinders futher
	CALL	#781B				; seek to cylinder 0

	CALL	#78B4				; recalibrate two times
	CALL	#780E				; wait 18 ms (head settle)

	
	;Test if disk B is landed on cyl 0
	
	LD	HL,076CAH			; wait max. 0.5 s (loop is 60T cycles)
loop:	
	LD	A,(#7FF8)
	AND	04H				; Disk landed on cylinder 0 ?
	JR	NZ,twodrive
	DEC	HL
	LD	A,H
	OR	L
	JR	NZ,loop

onedrive:
	LD	L,1
	jr stopit

twodrive:
	LD	L,2	
	
	
stopit:	
	CALL	#784B				; stop motor
	LD	(IX+7),L
	POP	AF
	JR	Z,toend				; CTRL pressed, do not use phantom drives
	LD	L,2				; 2 drives
toend:
	POP	DE
	POP	BC
	RET	
	
	
	
	
	
	
	
	

  ;recalibrate Dive B & A
  
	output Diskrom1.8-ORG.rom
	defpage 1,4000h,8000h
	page 1
	
	org #7861	
	
	PUSH	BC
	PUSH	DE
	PUSH	AF
	CALL	#5FC2       ; GETWRK
	POP	AF
	PUSH	AF
	JR	Z,X7887       ; CTRL pressed, skip drive 1 check
	LD	A,0C5H
	LD	(#7FFD),A	    ; motor on, in use, set b2, select drive 1
	RES	5,D
	CALL	#7835       ; seek to 5 cylinders futher
	CALL	#781B       ; seek to cylinder 0
	LD	HL,076CAH     ; wait max. 0.5 s (loop is 60T cycles)
X787B:	LD	A,(#7FF8)
	AND	04H
	JR	NZ,X788B
	DEC	HL
	LD	A,H
	OR	L
	JR	NZ,X787B
X7887:	LD	L,1
	JR	X7893

X788B:	LD	L,2
	CALL	#78B4       ; recalibrate two times
	CALL	#780E       ; wait 18 ms (head settle)
X7893:	LD	A,0C4H
	LD	(#7FFD),A     ; motor on, in use, set b2, select drive 0
	RES	5,D
	CALL	#7835       ; seek to 5 cylinders futher
	CALL	#781B       ; seek to cylinder 0
	CALL	#78B4       ; recalibrate two times
	LD	(IX+7),L
	CALL	#780E       ; wait 18 ms (head settle)
	CALL	#784B       ; stop motor
	POP	AF
	JR	Z,X78B1       ; CTRL pressed, do not use phantom drives
	LD	L,2           ; 2 drives
X78B1:	POP	DE
	POP	BC
	RET	

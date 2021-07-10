; Play WAV file on PSG soundchip
; Ported by Lars The 18Th
;
;
; Thanks to Ricardo Bittencourt
; https://github.com/ricbit/Oldies/tree/master/1997-10-readwav
;
; 

	output PlayWav.com
	
	defpage 0,100h
	page 0
	code @ 100h




main:
					di
					ld	a,7
					out	(#a0),a
					in	a,(#a2)
					and	11000000b
					or	00111110b
					out	(#a1),a

					ld	a,0
					out	(#a0),a
					ld	a,0
					out	(#a1),a

					ld	a,1
					out	(#a0),a
					ld	a,0
					out	(#a1),a	
					
					ld	a,8
					out	(#a0),a
					ld	a,#0f
					out	(#a1),a

					ld	hl,buffer
					ld	de,0

main0:
					; synch delay
					; must be adjusted by hand
					; in a trial-and-error way
					; this value was obtained for 11 khz

					ld	b,15
main1:				djnz	main1

					ld	a,(hl)
					srl	a
					srl	a
					srl	a
					srl	a
					out	(#a1),a
					inc	hl	
					inc	de
					ld	a,(total+1)
					cp	d
					jr	nz,main0

					ld	hl,buffer
					ld	de,0

exit:
					ld	a,7
					out	(#a0),a
					in	a,(#a2)
					and	11000000b
					or	00111111b
					out	(#a1),a
					ei	
					jp	0
					;exit


;----------------- sampledata 11khz 8-bit wav Made with SoundRecorder in Windows XP-------------
total:				dw	bufferend-buffer			;Lenght of buffer

buffer:
					incbin 8bit.wav,#5c				;Include WAV Sample file and discard the Header
					;incbin Pindakaas.wav,#5c		;Include WAV Sample file and discard the Header

bufferend:					
					end









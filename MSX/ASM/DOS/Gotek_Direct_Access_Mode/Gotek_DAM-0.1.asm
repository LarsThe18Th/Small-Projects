; Gotek Direct Access Mode v0.1
; Only for WD2793 Floppy Drive Controllers 
; (Used in e.g. Philips NMS 82xx MSX Computers)
;

    output gotek.com

    defpage 0,100h
    page 0
    code @ 100h


                in a,(#a8)                        ; Backup current slot
                push af
                ld a,(#ffff)                      ; Backup current SUB slot
                cpl
                push af
                
                ld a,(#f348)                      ; Read DiskROM Slot Location
                ld h,%01000000                    ; Set page 1
                call #24

                ; Set FDC controller values
                ; Is drive BUSY, Read status bit 0
busy:
                ld a,(#7ff8)                      ; Read STATUS Register
                and 1                             ; is bit 0 set
                jr nz,busy                        ; Yes the busy
                
                ld a,255
                ld (#7ffb),a                      ; Set destination TRACK in DATA Register

                xor a
                ld (#7ffc),a                      ; Select Side 0
                
                ld a,20
                ld (#7ff8),a                      ; Write SEEK command with verify in COMMAND REGISTER               

                ; Restore Slots
                pop af
                ld (#ffff),a                      ; Restore current SUB slot
                pop af
                out (#a8),a                       ; Restore current slot 
                
                ret
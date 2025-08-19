            output CUBECRC.com           ; Output-bestand voor SJASM assembler

            ORG #0100                   ; MSX-DOS .COM bestand begint op 0100h

; === CONSTANTEN ===
ROM_PRIMARY_SLOT    EQU #01          ; Primaire slot (0–3)
ROM_SECONDARY_SLOT  EQU #00          ; Secundaire slot (0–3)
RDSLT               EQU #000C        ; BIOS: lees byte uit slot
BDOS                EQU #0005        ; MSX-DOS BDOS entrypoint
BDOS_PRINT          EQU #09          ; BDOS functie 9: toon $-afgesloten string

; ==========================================================================
; CODE
; ==========================================================================
            JP START

; --------------------------------------------------------------------------
; MAIN ROUTINE
; --------------------------------------------------------------------------
START:
            ; Init CRC = 0xFFFFFFFF
            LD HL, CRC0
            LD (HL), #FF
            INC HL
            LD (HL), #FF
            INC HL
            LD (HL), #FF
            INC HL
            LD (HL), #FF

            ; Bouw slot-ID in register A:
            ; bits 0–1: primaire slot
            ; bits 2–3: secundaire slot
            ; bit 7 = 0 (niet-uitgebreid slot)
            LD A, ROM_SECONDARY_SLOT
            SLA A
            SLA A                  ; → bits 2–3
            OR ROM_PRIMARY_SLOT    ; bits 0–1
            LD (SLOT_ID), A

            ; Startadres voor ROM-lezen
            LD HL, #0000

READ_LOOP:
            LD A, H
            CP #0C0                 ; Stoppen bij HL >= 0xC0 (48 KB)
            JP NC, DONE

            PUSH HL
            LD A, (SLOT_ID)
            CALL RDSLT
            CALL UPDATE_CRC32
            POP HL

            INC HL
            JP READ_LOOP

DONE:
            ; Copy from ROM_PRIMARY_SLOT to page 1 RAM
            IN A, (#A8)
            LD B, A
            AND #3F
            LD C, A
            LD A, ROM_PRIMARY_SLOT
            RRCA
            RRCA
            OR C
            OUT (#A8), A

            LD A, B
            LD BC, #4000
            LD DE, #4000
            LD HL, #C000
            LDIR

            OUT (#A8), A

            ; Recalculate CRC32 on copied RAM page
            LD BC, #4000
            LD HL, #4000

PART3:
            LD A, (HL)
            PUSH HL
            CALL UPDATE_CRC32
            POP HL
            INC HL
            DEC BC
            LD A, B
            OR C
            JP NZ, PART3

            ; XOR CRC32 met 0xFFFFFFFF (bit-inversie)
            LD HL, CRC0
            LD A, (HL)
            XOR #FF
            LD (HL), A
            INC HL
            LD A, (HL)
            XOR #FF
            LD (HL), A
            INC HL
            LD A, (HL)
            XOR #FF
            LD (HL), A
            INC HL
            LD A, (HL)
            XOR #FF
            LD (HL), A

            CALL CRC_TO_STRING

            ; Check if CRC matches WRONG_CRC to warn about cartridge slot
            LD HL, CRC_HEX
            LD DE, WRONG_CRC
            LD BC, #8                 ; lengte CRC-string

CHECK_LOOP:
            LD A, (HL)
            LD B, A
            LD A, (DE)
            CP B
            JP NZ, CHECK_DONE
            INC HL
            INC DE
            DEC BC
            JP NZ, CHECK_LOOP

            ; CRC matches wrong cartridge signature → print warning
            LD DE, WARNING_MSG
            LD C, BDOS_PRINT
            LD HL, WARNING_MSG
            CALL BDOS
            JP END_PROGRAM

CHECK_DONE:
            ; CRC ok → print normal CRC message
            LD DE, CRC_MSG
            LD C, BDOS_PRINT
            LD HL, CRC_MSG
            CALL BDOS

END_PROGRAM:
            RET

; --------------------------------------------------------------------------
; UPDATE_CRC32
; A = byte, werkt CRC0..CRC3 bij (bit voor bit)
; --------------------------------------------------------------------------
UPDATE_CRC32:
            LD (TEMP_BYTE), A
            LD A, #8
            LD (BIT_COUNT), A

BIT_LOOP:
            LD A, (TEMP_BYTE)
            LD HL, CRC0
            XOR (HL)
            AND #1
            LD E, A

            ; Shift CRC >> 1
            LD A, (CRC3)
            SRL A
            LD (CRC3), A

            LD A, (CRC2)
            RR A
            LD (CRC2), A

            LD A, (CRC1)
            RR A
            LD (CRC1), A

            LD A, (CRC0)
            RR A
            LD (CRC0), A

            LD A, E
            OR A
            JR Z, NO_XOR

            ; XOR met 0xEDB88320 (little endian)
            LD HL, CRC0
            LD A, (HL)
            XOR #20
            LD (HL), A
            INC HL
            LD A, (HL)
            XOR #83
            LD (HL), A
            INC HL
            LD A, (HL)
            XOR #B8
            LD (HL), A
            INC HL
            LD A, (HL)
            XOR #ED
            LD (HL), A

NO_XOR:
            LD HL, TEMP_BYTE
            LD A, (HL)
            SRL A
            LD (HL), A

            LD HL, BIT_COUNT
            DEC (HL)
            JP NZ, BIT_LOOP

            RET

; --------------------------------------------------------------------------
; CRC_TO_STRING
; Zet CRC3..CRC0 om naar 8 ASCII hex chars in CRC_HEX
; --------------------------------------------------------------------------
CRC_TO_STRING:
            LD HL, CRC_HEX
            LD DE, CRC3        ; MSB eerst
            LD B, #4           ; 4 bytes → 8 karakters

NEXT_BYTE:
            LD A, (DE)
            PUSH DE
            CALL BYTE_TO_HEX
            LD (HL), D
            INC HL
            LD (HL), E
            INC HL
            POP DE
            DEC DE
            DJNZ NEXT_BYTE
            RET

; --------------------------------------------------------------------------
; BYTE_TO_HEX
; Zet A om naar 2 ASCII hex karakters → D (hoog), E (laag)
; --------------------------------------------------------------------------
BYTE_TO_HEX:
            PUSH AF
            RRA
            RRA
            RRA
            RRA
            AND #0F
            CALL NIBBLE_TO_ASCII
            LD D, A
            POP AF
            AND #0F
            CALL NIBBLE_TO_ASCII
            LD E, A
            RET

; --------------------------------------------------------------------------
; NIBBLE_TO_ASCII
; Zet nibble (0–15) om naar ASCII ('0'–'9', 'A'–'F')
; --------------------------------------------------------------------------
NIBBLE_TO_ASCII:
            CP #0A
            JR C, IS_DIGIT
            ADD A, 'A' - 10
            RET
IS_DIGIT:
            ADD A, '0'
            RET

; ==========================================================================
; DATA SEGMENT
; ==========================================================================
CRC0:       DB #00
CRC1:       DB #00
CRC2:       DB #00
CRC3:       DB #00

TEMP_BYTE:  DB #00
BIT_COUNT:  DB #00
SLOT_ID:    DB #00               ; Correct berekende slot-ID voor RDSLT

CRC_MSG:    DB "CRC32: "
CRC_HEX:    DB "        $"         ; 8 spaties + $-terminator

WRONG_CRC:  DB "DEAB7E4E"          ; Waarde die aangeeft cartridge in verkeerd slot of afwezig

WARNING_MSG: DB "Cartridge in verkeerd slot of is niet aanwezig$"

## MSX ClockChip  
  
This example writes a 'Save State' to the MSX ClockChip.
Now you can start the game 'FireHawk' in the final level.  
  
- ClockChipR-W-with-I-O.asm Writes to ClockChip with I/O Ports.  
- ClockChipR-W-with-BIOS.asm Writes to CLockChip with BIOS calls.


### Registers and Blocks overview
| Register | 0	| 1	| 2	| 3	| 4	| 5	| 6	| 7	| 8	| 9	| 10 | 11 | 12| 13 | 14 | 15 |
| -------- |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |
| Block 0 |*0*|*1*|*2*|*3*|*4*|*5*|*6*|*7*|*8*|*9*|*A*|*B*|*C*|`D`|`E`|`F`|
| Block 1 |*10*|*11*|*12*|*13*|*14*|*15*|*16*|*17*|*18*|*19*|1A|1B|1C|`1D`|`1E`|`1F`|
| Block 2 |*20*|*21*|*22*|*23*|*24*|*25*|*26*|*27*|*28*|*29*|2A|2B|2C|`2D`|`2E`|`2F`|
| Block 3 |*30*|*31*|*32*|*33*|*34*|*35*|*36*|*37*|*38*|*39*|3A|3B|3C|`3D`|`3E`|`3F`|

[Real Time Clock Programming Guide](https://www.msx.org/wiki/Real_Time_Clock_Programming)

### OpenMSX-debuggable view: (Realtime clock SRAM)
| Register | 0	| 1	| 2	| 3	| 4	| 5	| 6	| 7	| 8	| 9	| 10 | 11 | 12| 
| -------- |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |:---: |
| Block 0 |*0*|*1*|*2*|*3*|*4*|*5*|*6*|*7*|*8*|*9*|*A*|*B*|*C*|
| Block 1 |*D*|*E*|*F*|*10*|*11*|*12*|*13*|*14*|*15*|*16*|*17*|*18*|*19*|
| Block 2 |*1A*|*1B*|*1C*|*1D*|*1E*|*1F*|*20*|*21*|*22*|*23*|*24*|*25*|*26*|
| Block 3 |*27*|*28*|*29*|*2A*|*2B*|*2C*|*2D*|*2E*|*2F*|*30*|*31*|*32*|*33*|
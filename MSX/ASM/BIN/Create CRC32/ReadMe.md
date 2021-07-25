


## Creates CRC32 Hash of the DISKROM to ID version number  
  
This example creates a CRC32 Hash number to identify the DISKROM version.  
The last 8 bytes are discarded and replaced by FF, 
these registers are used by the diskrom as parameters.

Copy the bin file to a floppy and run it with bload"crc32-0.X.bin",r (please remove SD-Flashrom or other storage devices first).  
 
**This list contains a few common DiskROM CRC's**  

	#2c63df0e	;Philips DiskROM 1.8 Swap boot seek A-B
	#61f6fcd3	;Philips DiskROM 1.8
	#f3f17306	;Philips DiskROM 1.9
	#10a13aa3	;Sony Diskrom HB-F500p
	#f83d0ea6	;Sony Diskrom HB-F900p
	#70B23DCF	;Mega Flashrom SD
	#905daa1b	;Panasonic FS-A1WX
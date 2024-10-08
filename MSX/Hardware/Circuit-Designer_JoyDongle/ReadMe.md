## Circuit-Designer Joystick Dongle (Copy Protection)


![Circuit-Designer.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/CD_front.jpg)

<br>

The original Circuit-Designer Joystick Dongle looks like this.  
 
![The original dongle looks like this.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/Original_Dongle.jpg)  

A Quad 2-input NAND Gate IC is used with the following logic.  

![Qnand.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/Qnand.jpg)

<br>

After reverse engineering the Circuit-Designer software, i created this truth table.

| Output | Output | Input |  
| :------------: | :------------: | :------------:|
| Pin<br> 7 | Pin<br> 6 | Pin<br> 1 | 
| 0 | 0 | 0 | 
| 0 | 1 | 1 | 
| 1 | 0 | 0 | 
| 1 | 1 | 0 |  

<br>

With the above truth table you can create the following logical diagram
with only a *NOT* and a *AND* gate.  


  
![You can create this with a NOT and an AND gate.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/notand.png)

<br>

My intention was to create the logic gates with only *(NPN)* transistors and resistors, this is the circuit I used.  

![Schematic.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/Schematic.jpg)  

<br>

After soldering the components on a perfboard, this is the end result.  

![Result.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/Circuit.jpg)  

<br>

To test the dongle, i wrote a testprogramm ```DongleTest.asm``` to see what the results are.  
The results should be ```0100``` as indicated in the truth table. *(dongle in Port 2)*  
Start with ```bload"test.bin",r ```

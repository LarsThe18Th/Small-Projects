## Circuit-Designer Joystick Dongle (Copy Protection)


![Circuit-Designer.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/CD_front.jpg)

<br>  
We have reverse engineered Circuit-Designer copy protection dongle.<br>
The original dongle looks like this.  

![The original dongle looks like this.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/Original_Dongle.jpg)

Truth table

| Output | Output | Input |  
| :------------: | :------------: | :------------:|
| Pin<br> 7 | Pin<br> 6 | Pin<br> 1 | 
| 0 | 1 | 1 | 
| 0 | 0 | 0 | 
| 0 | 1 | 0 | 
| 0 | 1 | 0 |  

 
You can create this with a NOT and an AND gate.   
![You can create this with a NOT and an AND gate.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/notand.png)

My intention was to make the logic gates with only transistors and resistors
![Schematic.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/Schematic.jpg)
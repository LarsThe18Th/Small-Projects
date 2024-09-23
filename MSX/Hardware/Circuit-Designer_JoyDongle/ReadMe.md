## Circuit-Designer Joystick Dongle (Copy Protection)


![Circuit-Designer.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/CD_front.jpg)
<br><br>

The original Circuit-Designer Joystick Dongle looks like this.  
![The original dongle looks like this.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/Original_Dongle.jpg)


After reverse engineering the Circuit-Designer software, I created this truth table.

| Output | Output | Input |  
| :------------: | :------------: | :------------:|
| Pin<br> 7 | Pin<br> 6 | Pin<br> 1 | 
| 0 | 1 | 1 | 
| 0 | 0 | 0 | 
| 0 | 1 | 0 | 
| 0 | 1 | 0 |  

 
With the above truth table you can create the following logical diagram
with only a NOT and a AND gate.   
![You can create this with a NOT and an AND gate.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/notand.png)

My intention was to make the logic gates with only transistors and resistors, this is the circuit I used.
![Schematic.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Circuit-Designer_JoyDongle/Schematic.jpg)
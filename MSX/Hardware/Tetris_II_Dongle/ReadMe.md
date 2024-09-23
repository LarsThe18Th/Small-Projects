## Tetris II Joystick Dongle (Copy Protection)


![Tetris_II](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Tetris_II_Dongle/Tetris2.jpg)

<br>

The original Tetris II Joystick Dongle looks something like this. (Photo of a clone dongle)  
 
![The original dongle looks like this.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Tetris_II_Dongle/T2_Dongle.jpg)  

<br>

A Quad 2-input NOR Gate IC is used with the following logic.  

![Qnor.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Tetris_II_Dongle/Qnor.jpg)

<br>

After reverse engineering the Tetris II game, i created this truth table.

| Output | Output | Input |  
| :------------: | :------------: | :------------:|
| Pin<br> 7 | Pin<br> 6 | Pin<br> 4 | 
| 0 | 0 | 0 | 
| 0 | 1 | 0 | 
| 1 | 0 | 1 | 
| 1 | 1 | 1 |  

<br>

To test the dongle, i wrote a testprogramm ```TTest.asm``` to see what the results are.  
The results should be ```0011``` as indicated in the truth table. *(dongle in Port 2)*  
Start with ```bload"ttest.bin",r ```

<br>

# P.s.  

After examining the schematic of the dongle, it appears that there is an even simpler solution for this dongle,  
by just soldering a Resistor between Pin 4 and Pin 7.  
![Resistor.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Tetris_II_Dongle/Resistor.jpg)  
``` ¯\_(ツ)_/¯  ```

  



# 8235-20 Dual External Floppy drives  

<br>
<br>

I managed to get an **A:** and **B:** drive working on the external connection at the back of the MSX **8235/20**.  
You only need to solder one wire for this. (See photo) *(This feeds the **DiskSelect0** signal to the external connector)*

![Extra Cable.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Joy_MIDI/Joy_MIDI.jpg)

Use a **Straight** flat cable (without twist) with 3 connectors to connect both drives on the MSX.  
The PC drive that will act as the **A:** drive needs to be to be modified to function as drive A:.  
A standard PC drive works for the **B** drive. (A Gotek also can be used for both drives)

If you use the external drive as the **A:** drive, the internal drive **A** can no longer be used, but you can always switch back to the internal **A:** drive if you prefer.  
In both cases, the **B:** drive can simply remain connected to the external port.

It is recommended to update the DiskROM to the 8245 version after that, you can format a double-sided disk using drive **A:**.  
The other mod (see photo) for the **Side-Select** and **In-Use** signals are not strictly necessary, this is only intended for the internal **A:** drive.  


You could then use a nice 3D printed enclosure with a 5V USB adapter for the power supply. (Optionally with an **A: <-> B:** switch)  

![Joy_MIDI.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Joy_MIDI/Joy_MIDI.jpg)
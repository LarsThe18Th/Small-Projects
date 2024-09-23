## Joy_MIDI  

<br>
<br>

A simple MIDI-OUT connection through the MSX joystick port,  
inspired by this [*MSX computer magazine* article.](https://www.msxcomputermagazine.nl/mccm/millennium/milc/hardware/topic_0.htm)  

![Joy_MIDI.](https://raw.githubusercontent.com/LarsThe18Th/Small-Projects/refs/heads/master/MSX/Hardware/Joy_MIDI/Joy_MIDI.jpg)

<br>

| DB9 | Cable | DIN |  
| :---------- | :--------------- | :------------------ |
| Pin 6 (Trg1)| 220 Ohm Resistor | MIDI Pin 5 (MIDI 2) | 
| Pin 5 (+5V) | 220 Ohm Resistor | MIDI Pin 4 (MIDI 1) | 
| Pin 9 (GND) | -------------------------| MIDI Pin 2 (SHIELD) |  

<br>
<br>

To play MIDI files you can use [*MIDRY*](https://www.msxcomputermagazine.nl/mccm/millennium/milc/hardware/topic_0.htm), a MIDI file player with GUI and support for several Japanese MIDI interfaces,  
including internal/external MSX-MIDI, MIDI Saurus and TADA-MIDI - also support for ReComPoser MIDI files (.RCP) (MSX2/2+/MSX turbo R)  

<br>

Start MIDRY with the following command  
 
Joy_MIDI in Port 1  
```midry /i31 midifile.mid```

Joy_MIDI in Port 2  
```midry /i32 midifile.mid```


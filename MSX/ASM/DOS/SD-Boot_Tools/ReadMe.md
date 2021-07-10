Flashrom-SD Boot Tools
----------------------

No need for MSX Basic anymore to change some settings,<br>
when booting from your SD-Flashrom drive as described [Here] (http://meits.nl/disk-online.html#mfrsccsd)


**first.com**
- Set some screen settings

	- Screen 0 
	- Width 80
	- 60Hz
	- Color 15,0,0


**setfkeys.com**
- Set F-Keys to folowing

	- Key1 opfxsd_
	- Key2 _system +CR
	- Key3 basic +CR
	- Key4 dir/w +CR
	- Key5 mm +CR
	- Key6 color 15,0,0 +CR
	- Key7 speedon +CR
	- Key8 speedoff +CR

**clock.com**
- Writes some settings to the ClockChip 

	- Beep 1,4
	- KeyClick Off
	- Border Color
	- Back Color
	- Fore Color
	- Width 80
	- Set Adjust (0,0)

**slot.com**
- Read slot of Current Disk Controller
	- If slot 1 1.BAT is started
	- If slot 2 2.BAT is started

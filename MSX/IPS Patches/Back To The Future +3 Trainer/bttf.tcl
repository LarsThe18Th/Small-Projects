set_help_text bttf "BTTF Level Select."

proc bttf {} {

			keymatrixdown 8 16
			keymatrixdown 8 32
			keymatrixdown 7 64	
			keymatrixdown 8 01			
			
			after frame {
				keymatrixup 8 01
				keymatrixup 8 16
				keymatrixup 8 32
				keymatrixup 7 64			
			} 
}
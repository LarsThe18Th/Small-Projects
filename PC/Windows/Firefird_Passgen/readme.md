# The story behind Hinotori

<br><br>
If you are interested in the story behind Hinotori, please watch the Hinotori trilogy movies or the Hinotori series (English),  
this also explains some passwords and music used in the MSX game.

More information can be found on [Wikipedia](https://en.wikipedia.org/wiki/Phoenix_(manga)

Music: [Phoenix : Karma Chapter (火の鳥 . 鳳凰編) ED full 火の鳥 (渡辺典子)](https://www.youtube.com/watch?v=nF1Tr-Rxy7c "Phoenix : Karma Chapter (火の鳥 . 鳳凰編) ED full 火の鳥 (渡辺典子)")
By: NORIKO, WATANABE<br><br>

### Variable difficulty level in the MSX game.<br>

Firebird uses a variable difficulty level ( From 0 to 15 ),
the higher the difficulty level the more aggressive the enemies are.

The difficulty level will be increased in the following ways:
- The stronger the weapon, the higher the difficulty level (Strongest weapon +6)
- Every time a password is entered + 1 ( until level 10 is reached )
- Every time you defeat a boss +1


### Debug mode

While decoding the password system in the ROM, i found this password "aaaaa".
Firebird passwords are uppercase only, therefore it is not possible
to enter this password during the game, so i have made an IPS patch
to change the password into "AAAAA". Now it is possible to use
this password and activate the hidden debug mode.

After patching the rom you can enter debug mode with password "AAAAA"
- Makes you invulnerable to enemies
- Have all items and stones
- Shows leveldata, Left Level posittion, Right Enemy attackwave pattern.

[Download Firebird Debugmode IPS Patch](https://github.com/LarsThe18Th/Small-Projects/tree/master/MSX/IPS%20Patches/Firebird%20Debug%20Mode%20Patch "Download Firebird Debugmode IPS Patch")


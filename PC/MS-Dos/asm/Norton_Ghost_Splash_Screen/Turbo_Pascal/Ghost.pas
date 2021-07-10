program Ghost;
uses crt;

label skip;

var dat, test            : string;
var i, code, getal       : integer;


begin

{#  SCREEN 0}

clrscr;


{dim dat as string}

dat := dat + '   _____ _____ _   _ _____ _____                  111111111111111111111111111111';
dat := dat + '  / ____|_   _| \ | |_   _/ ____|                 111111111111333311111111111111';
dat := dat + ' | |      | | |  \| | | || |                      111111111132311111131111111111';
dat := dat + ' | |____ _| |_| |\  |_| || |____                  132311111132111111122111111111';
dat := dat + '  \_____|_____|_| \_|_____\_____|                 122423111221141111122111111111';
dat := dat + '                                                  111244423231111114133111111111';
dat := dat + '        _____            __                       111113233111111111133111111111';
dat := dat + '       / ___/__  _______/ /____  ____ ___  _____  111111111111111111113113333311';
dat := dat + '       \__ \/ / / / ___/ __/ _ \/ __ `__ \/ ___/  123111111111111111111132222441';
dat := dat + '      ___/ / /_/ (__  ) /_/  __/ / / / / (__  )   124311111111111111111111111441';
dat := dat + '     /____/\__  /____/\__/\___/_/ /_/ /_/____/    134211111111111111111111111441';
dat := dat + '          /____/                                  112411111111111111111111112431';
dat := dat + '                                                  113411111111111111111111124211';
dat := dat + '         Ghost Boot-CD                            111243111111111111111111344311';
dat := dat + '                                                  111242111111111111111113443111';
dat := dat + '                                                  111342111111111111111134431111';
dat := dat + '                                                  111143111111111111111244311111';
dat := dat + '                                                  111143111111111111124431111111';
dat := dat + '                                                  111243111111111112443111111111';
dat := dat + '                                                  111323111111112442211111111111';
dat := dat + '                                                  113231111322244331111111111111';
dat := dat + '                                                  124444444423331111111111111111';
dat := dat + '                                                  111111111111111111111111111111';

writeln(length(dat));


FOR i := 1 TO length(dat) do
begin

    {test := dat[1];}

    if dat[i] = '1'
       then
           Begin
           textcolor (15);
           write('Û');
           goto skip
           end;

    if dat[i] = '2'
       then
           Begin
           textcolor (8);
           write('Û');
           goto skip
           end;

    if dat[i] = '3'
       then
           Begin
           textcolor (7);
           write('Û');
           goto skip;
           end;

    if dat[i] = '4'
       then
           Begin
           textcolor (0);
           TextBackground(0);
           write('Û');
           goto skip;
           end;

    write(dat[i]);

skip:

{
IF val(MID$(dat, i, 1)) = 1 THEN COLOR 15: PRINT "Û";
IF val(MID$(dat, i, 1)) = 2 THEN COLOR 8: PRINT "Û";
IF val(MID$(dat, i, 1)) = 3 THEN COLOR 7: PRINT "Û";
IF val(MID$(dat, i, 1)) = 4 THEN COLOR 0, 0, 0: PRINT " ";
IF val(MID$(dat, i, 1)) = 0 THEN : COLOR 15, 9, 9: PRINT MID$(dat, i, 1);

' r = r + 1
' IF r = 80 THEN r = 0: PRINT
}

end;

end.


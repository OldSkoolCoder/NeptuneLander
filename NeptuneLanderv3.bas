10 GOSUB 250 : poke 53269,1 : REM bit 0 = sprite 0
20 POKE 2040,190 : REM SPRITE POINT * 64 = 190 * 64 = 12160
30 Y = 60 : POKE 53249,Y
40 X = 60 : POKE 53248,X
50 POKE 53287,0
55 FORI=0TO103:READA:POKE12*1024+I,A:NEXT : POKE53272,28
60 FOR I = 0 TO 62 : READ A : POKE 12160 + I, A : NEXT I
80 VV = 0 : G = 3/28 : T = 3/28 : HV = 0 : HI = 1/28 : CC = 0
90 REM FOR DE = 0 TO 32 : NEXT
95 REM ST$ = TI$
100 A = PEEK(197)
110 IF A = 22 THEN VV = VV - T : GOTO 210 : REM T
120 IF A = 18 THEN HV = HV - HI : REM D
130 IF A = 10 THEN HV = HV + HI : REM A
140 REM IF A = 9 THEN Y=(Y+1) AND 255 : POKE 53249,Y : REM W
150 REM IF A = 12 THEN Y=(Y-1) AND 255 : POKE 53249,Y : REM Z

200 VV = VV + G : IF VV > 2 THEN VV = 2
201 IF VV < -2 THEN VV = -2
210 Y = (Y+VV) : X = (X+HV)
212 IF X > 255 OR X < 0 THEN X = X AND 255
213 IF Y > 255 OR Y < 0 THEN Y = Y AND 255
214 POKE 53249, Y : POKE 53248,X : REM CC=CC+1
215 REM PRINT "{clear}";Y;VV
218 REM IF ST$ <> TI$ THEN END
220 GOTO 90

250 REM First Level Screen layout.
260 PRINT"{clear}{white}{down*8}gg{down}bc{down}d{down}h{down}{left}j{down}h{down}{left}j{down}{left}i{down}{left}k{down}{left*2}e{down}{left*3}@a{down}{left*3}e{down}{left*2}e{down}{left}d{down}d{down}d{down}dlllk{up}{left}i";
270 PRINT"{up}{left}j{up}{left}h{up}{left}e{up}e{up}@a{up}e{up}k{up}{left}i{up}k{up}{left}i{up}lllk{up}{left}i{up}{left}d{up}{left*2}d{up}{left}@a{up}e{up}k{up}{left}i{up}f{down}dgg{down}h{down}{left}j{down}h{down}{left}j";
280 PRINT"{down}{left}i{down}{left}k{down}{left}h{down}{left}j{down}h{down}{left}j{down}{left}e{down}{left*2}e{down}{left}h{down}{left}j{down}d{down}bcllllebc{down}bc{down}d";
290 RETURN

900 DATA 0,0,0,5,10,16,96,128 : REM CHARACTER 0
905 DATA 1,5,8,144,96,0,0,0 : REM CHARACTER 1
910 DATA 128,64,64,80,105,6,0,0 : REM CHARACTER 2
915 DATA 0,0,0,0,132,74,49,1 : REM CHARACTER 3
920 DATA 128,64,48,8,4,4,6,1 : REM CHARACTER 4
925 DATA 1,1,2,10,20,16,32,192 : REM CHARACTER 5
930 DATA 0,0,8,20,36,66,65,129 : REM CHARACTER 6
935 DATA 0,0,0,0,4,42,209,129 : REM CHARACTER 7
940 DATA 128,64,64,32,16,16,8,8 : REM CHARACTER 8
945 DATA 1,1,2,4,2,2,4,8 : REM CHARACTER 9
950 DATA 4,2,2,4,2,2,1,1 : REM CHARACTER 10
955 DATA 8,16,32,32,32,64,64,128 : REM CHARACTER 11
960 DATA 0,0,0,0,0,0,0,255 : REM CHARACTER 12


999 END
1000 REM 
1010 DATA 16,0,18
1020 DATA 8,126,28
1030 DATA 5,255,204
1040 DATA 6,16,54
1050 DATA 15,159,240
1060 DATA 8,146,16
1070 DATA 8,243,240
1080 DATA 8,242,16
1090 DATA 8,244,8
1100 DATA 31,254,24
1110 DATA 32,1,244
1120 DATA 32,0,164
1130 DATA 39,128,188
1140 DATA 39,192,164
1150 DATA 31,255,252
1160 DATA 13,60,176
1170 DATA 25,195,152
1180 DATA 49,0,140
1190 DATA 48,0,12
1200 DATA 120,0,30
1210 DATA 204,0,51

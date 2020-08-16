;===============================================================================
; $00-$FF  PAGE ZERO (256 bytes)
 
                ; $00-$01   Reserved for IO
ZeroPageTemp    = $02
                ; $03-$8F   Reserved for BASIC
                ; using $73-$8A CHRGET as BASIC not used for our game
ZeroPageParam1  = $73
ZeroPageParam2  = $74
ZeroPageParam3  = $75
ZeroPageParam4  = $76
ZeroPageParam5  = $77
ZeroPageParam6  = $78
ZeroPageParam7  = $79
ZeroPageParam8  = $7A
ZeroPageParam9  = $7B
                ; $90-$FA   Reserved for Kernal
ZeroPageLow     = $45
ZeroPageHigh    = $46
ZeroPageLow2    = $47
ZeroPageHigh2   = $48
                ; $FF       Reserved for Kernal

;===============================================================================
; $0200-$9FFF  RAM (40K)

SCREENRAM       = $0400
SPRITE0         = $07F8

; $0801
; Game code is placed here by using the *=$0801 directive 
; in gameMain.asm 


; 192 decimal * 64(sprite size) = 10880(hex $2A80)
SPRITERAM       = 170

;===============================================================================
; $D000-$DFFF  IO (4K)

; These are some of the C64 registers that are mapped into
; IO memory space
; Names taken from 'Mapping the Commodore 64' book

SP0X            = $D000
SP0Y            = $D001
MSIGX           = $D010
SCROLY          = $D011
RASTER          = $D012
SPENA           = $D015
SCROLX          = $D016
VMCSB           = $D018
VICIRQ          = $D019
SPBGPR          = $D01B
SPMC            = $D01C
SPSPCL          = $D01E
SPBGCL          = $D01F
EXTCOL          = $D020
BGCOL0          = $D021
BGCOL1          = $D022
BGCOL2          = $D023
BGCOL3          = $D024
SPMC0           = $D025
SPMC1           = $D026
SP0COL          = $D027
FRELO1          = $D400 ;(54272)
FREHI1          = $D401 ;(54273)
PWLO1           = $D402 ;(54274)
PWHI1           = $D403 ;(54275)
VCREG1          = $D404 ;(54276)
ATDCY1          = $D405 ;(54277)
SUREL1          = $D406 ;(54278)
FRELO2          = $D407 ;(54279)
FREHI2          = $D408 ;(54280)
PWLO2           = $D409 ;(54281)
PWHI2           = $D40A ;(54282)
VCREG2          = $D40B ;(54283)
ATDCY2          = $D40C ;(54284)
SUREL2          = $D40D ;(54285)
FRELO3          = $D40E ;(54286)
FREHI3          = $D40F ;(54287)
PWLO3           = $D410 ;(54288)
PWHI3           = $D411 ;(54289)
VCREG3          = $D412 ;(54290)
ATDCY3          = $D413 ;(54291)
SUREL3          = $D414 ;(54292)
SIGVOL          = $D418 ;(54296)      
COLORRAM        = $D800
CIAPRA          = $DC00
CIAPRB          = $DC01

; Kernel Jump Vectors
krljmp_PCINT$       = $FF81
krljmp_IOINIT$      = $FF84
krljmp_RAMTAS$      = $FF87
krljmp_RESTOR$      = $FF8A
krljmp_VECTOR$      = $FF8D
krljmp_SETMSG$      = $FF90
krljmp_SECOND$      = $FF93
krljmp_TKSA$        = $FF96
krljmp_MEMTOP$      = $FF99
krljmp_MEMBOT$      = $FF9C
krljmp_SCNKEY$      = $FF9F
krljmp_SETTMO$      = $FFA2
krljmp_ACPTR$       = $FFA5
krljmp_CIOUT$       = $FFA8
krljmp_UNTALK$      = $FFAB
krljmp_UNLSN$       = $FFAE
krljmp_LISTEN$      = $FFB1
krljmp_TALK$        = $FFB4
krljmp_READST$      = $FFB7
krljmp_SETLFS$      = $FFBA
krljmp_SETNAM$      = $FFBD
krljmp_OPEN$        = $FFC0
krljmp_CLOSE$       = $FFC3
krljmp_CHKIN$       = $FFC6
krljmp_CHKOUT$      = $FFC9
krljmp_CLRCHN$      = $FFCC
krljmp_CHRIN$       = $FFCF
krljmp_CHROUT$      = $FFD2
krljmp_LOAD$        = $FFD5
krljmp_SAVE$        = $FFD8
krljmp_SETTIM$      = $FFDB
krljmp_RDTIM$       = $FFDE
krljmp_STOP$        = $FFE1
krljmp_GETIN$       = $FFE4
krljmp_CLALL$       = $FFE7
krljmp_UDTIM$       = $FFEA
krljmp_SCREEN$      = $FFED
krljmp_PLOT$        = $FFF0
krljmp_BASE$        = $FFF3

LSTX                = 197

;spLunaLander    = 0
;spLunaLanderWindows = 18
;spThrustDown    = 2
;spThrustLeft    = 4
;spThrustRight   = 3
spNoThrust      = 5

GF_InFlight     = 1
GF_Landed       = 2
GF_Dying        = 3
GF_Dead         = 4
GF_Menu         = 0
GF_Title        = 5
GF_Retry        = 6
GF_NextLevel    = 7
GF_UpdateScore  = 8
GF_Initialise   = 9
GF_Difficulty   = 10
GF_DiedSoTryAgain = 11
GF_LostInSpace  = 12

GD_Easy = 0
GD_Normal = 1
GD_Hard = 2

scDisplayScoringLocationH = $07D4
scDisplayScoringLocationM = $07D6
scDisplayScoringLocationL = $07D8

;Peek(197) Codes
scanCode_INS_DEL$ = 0
scanCode_RET$ = 1
scanCode_CUR_RI$ = 2 
scanCode_F7$ = 3
scanCode_F1$ = 4
scanCode_F3$ = 5 
scanCode_F5$ = 6 
scanCode_CUR_DN$ = 7 
scanCode_3$ = 8 
scanCode_W$ = 9 
scanCode_A$ = 10
scanCode_4$ = 11
scanCode_Z$ = 12
scanCode_S$ = 13
scanCode_E$ = 14
scanCode_5$ = 16
scanCode_R$ = 17
scanCode_D$ = 18
scanCode_6$ = 19
scanCode_C$ = 20
scanCode_F$ = 21
scanCode_T$ = 22
scanCode_X$ = 23
scanCode_7$ = 24
scanCode_Y$ = 25
scanCode_G$ = 26
scanCode_8$ = 27
scanCode_B$ = 28
scanCode_H$ = 29
scanCode_U$ = 30
scanCode_V$ = 31
scanCode_9$ = 32
scanCode_I$ = 33
scanCode_J$ = 34
scanCode_0$ = 35
scanCode_M$ = 36
scanCode_K$ = 37
scanCode_O$ = 38
scanCode_N$ = 39
scanCode_PLUS$ = 40
scanCode_P$ = 41
scanCode_L$ = 42
scanCode_MINUS$ = 43
scanCode_FULSTP$ = 44
scanCode_COLON$ = 45
scanCode_AT$ = 46
scanCode_COMMA$ = 47
scanCode_POUND$ = 48
scanCode_ASTRIK$ = 49
scanCode_SEMICOLON$ = 50
scanCode_CLEAR_HOME$ = 51
scanCode_EQUALS$ = 53
scanCode_EXPONENT_ARROW$ = 54
scanCode_FWD_SLASH$ = 55
scanCode_1$ = 56
scanCode_LEFT_ARROW$ = 57
scanCode_2$ = 59
scanCode_SPACEBAR$ = 60
scanCode_Q$ = 62
scanCode_RUNSTOP$ = 63
scanCode_NO_KEY$ = 64


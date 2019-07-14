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
ZeroPageLow     = $FB
ZeroPageHigh    = $FC
ZeroPageLow2    = $FD
ZeroPageHigh2   = $FE
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
RASTER          = $D012
SPENA           = $D015
SCROLX          = $D016
VMCSB           = $D018
VICIRQ          = $D019
SPBGPR          = $D01B
SPMC            = $D01C
SPSPCL          = $D01E
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

spLunaLander    = 0
spThrustDown    = 2
spThrustLeft    = 3
spThrustRight   = 4
spNoThrust      = 5

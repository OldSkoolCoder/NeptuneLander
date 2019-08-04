; 10 SYS (2080)

*=$0801

        BYTE $0E, $08, $0A, $00, $9E, $20, $28  
        BYTE $32, $30, $38, $30, $29, $00, $00, $00

; Sprite Data
*=$2A80
; Load Sprites 1-> 5 padded to 64 bytes
incbin "NeptuneLander.spt", 1, 6 ,true
incbin "DereksExplosions.spt", 5, 16, true

; CharacterSet
*=$3000
incbin "LandScape.cst", 0, 127

*=$0820
        jmp GameStart

;*************************************************************************
;* Game Working Variable Space                                           *
;*************************************************************************

; Binary Fraction Format :-
;     First Byte is Fraction = 1/128 -> 1/2
;     Second Byte is Whole Number

LunaLanderXFrac
        brk

LunaLanderXLo
        brk

LunaLanderXHi
        brk

LunaLanderYFrac
        brk

LunaLanderY
        brk

LunaLanderSpNo
        BYTE 0

LunaLanderColour
        brk

ThrustSpNo
        BYTE 1

ThrustFrameNo
        brk

ThrustColour
        brk

VerticalVelocityFrac
        brk

VerticalVelocity
        brk

GravityFrac
        brk

Gravity
        brk

ThrustFrac
        brk

Thrust
        brk

HorizontalVelocityFrac
        brk

HorizontalVelocity
        brk

HorizontalInertiaFrac
        brk

HorizontalInertia
        brk


incasm "libSprite.asm"
incasm "libMath.asm"
incasm "libInput.asm"
incasm "libConstants.asm"
incasm "libScreen.asm"
incasm "libPrint.asm"

GameStart
        jsr SetUpLunarSprite
        jsr SetUpCustomCharacters
        jsr SetUpLevelOneScene

        jsr SetUpGameVariables

GameLoop
        LIBSCREEN_WAIT_V 255

        jsr ReadInputAndUpdateVariables
        jsr UpdateSpritePosition

        jsr libSpritesUpdate
        jmp GameLoop
        rts



SetUpLunarSprite
        lda #60
        sta LunaLanderXLo
        sta LunaLanderY
        lda #0
        sta LunaLanderXHi
        sta LunaLanderSpNo
        sta LunaLanderColour

        lda #Red
        sta ThrustColour

        ; POKE 53273, PEEK(53273) OR 2
        lda VICIRQ
        ora #2
        sta VICIRQ

        ; 20 POKE 2040,170 : REM SPRITE POINT * 64 = 170 * 64 = 10880
        ; 25 POKE 2041,186
        LIBSPRITE_SETFRAME_AV LunaLanderSpNo, spLunaLander
        LIBSPRITE_SETFRAME_AV ThrustSpNo, spNoThrust

        ;poke 53269,3
        LIBSPRITE_ENABLE_AV LunaLanderSpNo, True
        LIBSPRITE_ENABLE_AV ThrustSpNo, True

        ; 30 Y = 60 : POKE 53249,Y : POKE 53251,Y
        ; 40 X = 60 : POKE 53248,X : POKE 53250,X
        LIBSPRITE_SETPOSITION_AAAA LunaLanderSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ThrustSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY

        ; POKE 53287,0
        LIBSPRITE_SETCOLOR_AA LunaLanderSpNo, LunaLanderColour

        ; POKE 53288,2
        LIBSPRITE_SETCOLOR_AA ThrustSpNo, ThrustColour
        LIBSPRITE_SETMULTICOLORS_VV Yellow, LightGray
        rts

SetUpCustomCharacters
        LIBSCREEN_SETCHARMEMORY 12
        rts

ScnLevelOne
        TEXT "{clear}{white}{down*8}gg{down}bc{down}d{down}h{down}{left}j{down}h{down}{left}j{down}{left}i{down}{left}k{down}{left*2}e{down}{left*3}@a{down}{left*3}e{down}{left*2}e{down}{left}d{down}d{down}d{down}dlllk{up}{left}i"
        TEXT "{up}{left}j{up}{left}h{up}{left}e{up}e{up}@a{up}e{up}k{up}{left}i{up}k{up}{left}i{up}lllk{up}{left}i{up}{left}d{up}{left*2}d{up}{left}@a{up}e{up}k{up}{left}i{up}f{down}dgg{down}h{down}{left}j{down}h{down}{left}j"
        TEXT "{down}{left}i{down}{left}k{down}{left}h{down}{left}j{down}h{down}{left}j{down}{left}e{down}{left*2}e{down}{left}h{down}{left}j{down}d{down}bcllllebc{down}bc{down}d"
        BYTE 0

SetUpLevelOneScene
        LIBPRINT_PRINTSTRING_A ScnLevelOne
        rts
        
        ;80 VV = 0 : G = 3/112 : T = 3/112 : HV = 0 : HI = 1/28
SetUpGameVariables
        lda #0
        sta VerticalVelocity
        sta HorizontalVelocity
        sta Gravity
        sta Thrust
        sta HorizontalInertia

        lda #1
        sta GravityFrac
        sta ThrustFrac
        lda #1
        sta HorizontalInertiaFrac

        rts

ReadInputAndUpdateVariables
        jsr libInputUpdate

        LIBINPUT_GETHELD GameportLeftMask
        bne @TestRight

        ;130 IF A = 10 THEN HV = HV + HI : TS = 185 :REM A
        LIBMATH_ADD16BIT_AAA HorizontalVelocityFrac, HorizontalInertiaFrac, HorizontalVelocityFrac
        ldx #spThrustLeft
        stx ThrustFrameNo
        jmp @InputProcessed

@TestRight
        LIBINPUT_GETHELD GameportRightMask
        bne @TestFire

        ;120 IF A = 18 THEN HV = HV - HI : TS = 184 : REM D
        LIBMATH_SUB16BIT_AAA HorizontalVelocityFrac, HorizontalInertiaFrac, HorizontalVelocityFrac
        ldx #spThrustRight
        stx ThrustFrameNo
        jmp @InputProcessed

@TestFire
        LIBINPUT_GETHELD GameportFireMask
        bne @NoInput

        ;110 IF A = 22 THEN VV = VV - T : TS=183 : 
@FireDetected
        LIBMATH_SUB16BIT_AAA VerticalVelocityFrac, ThrustFrac, VerticalVelocityFrac
        ldx #spThrustDown
        stx ThrustFrameNo
        jmp @GravityByPass

        ;200 VV = VV + G : IF VV > 2 THEN VV = 2
@NoInput
        ldx #spNoThrust
        stx ThrustFrameNo

@InputProcessed
        LIBMATH_ADD16BIT_AAA VerticalVelocityFrac, GravityFrac, VerticalVelocityFrac

@GravityByPass
        lda VerticalVelocity
        cmp #2
        bne @InputFinish

        lda #2
        sta VerticalVelocity
        lda #0
        sta VerticalVelocityFrac

@InputFinish
        rts

UpdateSpritePosition
        ; 210 Y = (Y+VV) : X = (X+HV)
        LIBMATH_ADD8BIT_AAA LunaLanderY, VerticalVelocity, LunaLanderY
        LIBMATH_ADD16BIT_AAA LunaLanderXLo, HorizontalVelocity, LunaLanderXLo

        ;215 POKE 2041,TS : POKE 53250, XL : POKE 53251, Y
        ;216 POKE 53249, Y : POKE 53248,XL : POKE 53264, XH : REM CC=CC+1
        LIBSPRITE_SETFRAME_AA ThrustSpNo, ThrustFrameNo

        lda #0
        sta LunaLanderXHi
        LIBSPRITE_SETPOSITION_AAAA LunaLanderSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ThrustSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY

        rts


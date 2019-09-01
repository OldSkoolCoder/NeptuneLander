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
incbin "LandScape.cst", 0, 255

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

ManuoverSpNo
        BYTE 2

ManuoverFrameNo
        brk

ManuoverColour
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

GameLoopFrameTracker
        brk

FrameSkipRate
        BYTE 03

CollidedWithBackground
        brk

VerticalBarValue
        brk

FuelBarValueFrac
        brk

FuelBarValue
        brk

ThrustCostFrac
        BYTE 64

ThrustCost
        brk

incasm "libSprite.asm"
incasm "libMath.asm"
incasm "libInput.asm"
incasm "libConstants.asm"
incasm "libScreen.asm"
incasm "libPrint.asm"
incasm "libBarsAndGauges.asm"

GameStart
        jsr SetUpLevelOneScene
        jsr SetUpLunarSprite
        jsr SetUpCustomCharacters

        jsr SetUpGameVariables

        LIBBARSANDGAUGES_INITYBAR_AV $044E,12
        lda #Green
        sta $D916

        LIBBARSANDGAUGES_INITYBAR_AV $044D,12
        lda #Red
        sta $D9DD
        sta $DA05
GameLoop
        LIBSCREEN_WAIT_V 255

        lda #1
        sta EXTCOL

        ;LIBSCREEN_DEBUG16BIT_VVAA 1,1,VerticalVelocity, VerticalVelocityFrac
        ;LIBSCREEN_DEBUG8BIT_VVA 8,1,LunaLanderY

        lda CollidedWithBackground
        cmp #False
        beq @NoGameDeathScene
        jmp GameDeathScene

@NoGameDeathScene
        lda GameLoopFrameTracker
        bne GameLooper

        jsr ReadInputAndUpdateVariables
        jsr UpdateSpritePosition
        jsr DidWeCollideWithScene

        jsr UpdateBarsAndGauges
GameLooper
        jsr libSpritesUpdate

        lda GameLoopFrameTracker
        clc
        adc #$01
        and FrameSkipRate
        sta GameLoopFrameTracker

        lda #0
        sta EXTCOL

        jmp GameLoop
        rts

GameDeathScene
        LIBSPRITE_ISANIMPLAYING_A LunaLanderSpNo
        bne GameLooper

        jsr libInputUpdate
        LIBINPUT_GETHELD GameportFireMask
        bne GameLooper

        jmp GameStart


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
        sta ManuoverColour

        ; POKE 53273, PEEK(53273) OR 2
        lda VICIRQ
        ora #2
        sta VICIRQ

        ; 20 POKE 2040,170 : REM SPRITE POINT * 64 = 170 * 64 = 10880
        ; 25 POKE 2041,186
        LIBSPRITE_SETFRAME_AV LunaLanderSpNo, spLunaLander
        LIBSPRITE_SETFRAME_AV ThrustSpNo, spNoThrust
        LIBSPRITE_SETFRAME_AV ManuoverSpNo, spNoThrust

        ;poke 53269,3
        LIBSPRITE_ENABLE_AV LunaLanderSpNo, True
        LIBSPRITE_ENABLE_AV ThrustSpNo, True
        LIBSPRITE_ENABLE_AV ManuoverSpNo, True

        ; 30 Y = 60 : POKE 53249,Y : POKE 53251,Y
        ; 40 X = 60 : POKE 53248,X : POKE 53250,X
        LIBSPRITE_SETPOSITION_AAAA LunaLanderSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ThrustSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ManuoverSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY

        ; POKE 53287,0
        LIBSPRITE_SETCOLOR_AA LunaLanderSpNo, LunaLanderColour

        ; POKE 53288,2
        LIBSPRITE_SETCOLOR_AA ThrustSpNo, ThrustColour
        LIBSPRITE_SETCOLOR_AA ManuoverSpNo, ManuoverColour
        LIBSPRITE_SETMULTICOLORS_VV Yellow, LightGray

        LIBSPRITE_MULTICOLORENABLE_AV LunaLanderSpNo, False

        rts

SetUpCustomCharacters
        LIBSCREEN_SETCHARMEMORY 12
        rts

ScnLevelOne
        TEXT "{white}{clear}{down*8}gg{down}bc{down}d{down}h{down}{left}j{down}h{down}{left}j{down}{left}i{down}{left}k{down}{left*2}e{down}{left*3}@a{down}{left*3}e{down}{left*2}e{down}{left}d{down}d{down}d{down}dlllk{up}{left}i"
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
        lda #False
        sta CollidedWithBackground

        lda #2
        sta GravityFrac
        lda #4
        sta ThrustFrac
        lda #2
        sta HorizontalInertiaFrac

        lda #8
        sta FuelBarValueFrac
        lda #0
        sta FuelBarValue

        rts

ReadInputAndUpdateVariables
        jsr libInputUpdate

        LIBINPUT_GETHELD GameportLeftMask
        bne @TestRight

        ;130 IF A = 10 THEN HV = HV + HI : TS = 185 :REM A
        LIBMATH_ADD16BIT_AAA HorizontalVelocityFrac, HorizontalInertiaFrac, HorizontalVelocityFrac
        ldx #spThrustLeft
        stx ManuoverFrameNo
        jsr AddFuelConsumption

@TestRight
        LIBINPUT_GETHELD GameportRightMask
        bne @TestFire

        ;120 IF A = 18 THEN HV = HV - HI : TS = 184 : REM D
        LIBMATH_SUB16BIT_AAA HorizontalVelocityFrac, HorizontalInertiaFrac, HorizontalVelocityFrac
        ldx #spThrustRight
        stx ManuoverFrameNo
        jsr AddFuelConsumption

@TestFire
        LIBINPUT_GETHELD GameportFireMask
        bne @NoInput

        ;110 IF A = 22 THEN VV = VV - T : TS=183 : 
@FireDetected
        LIBMATH_SUB16BIT_AAA VerticalVelocityFrac, ThrustFrac, VerticalVelocityFrac
        ldx #spThrustDown
        stx ThrustFrameNo
        jsr AddFuelConsumption
        jsr AddFuelConsumption
        jmp @GravityByPass

@NoInput
        LIBINPUT_GETHELD GameportNoInputMask
        cmp #GameportNoInputMask
        bne @InputProcessed
        ldx #spNoThrust
        stx ThrustFrameNo
        stx ManuoverFrameNo

        ;200 VV = VV + G : IF VV > 2 THEN VV = 2
@InputProcessed
        LIBMATH_ADD16BIT_AAA VerticalVelocityFrac, GravityFrac, VerticalVelocityFrac

@GravityByPass
        lda VerticalVelocity
        cmp #2
        bne @InputFinish

        lda #1
        sta VerticalVelocity
        lda #0
        sta VerticalVelocityFrac

@InputFinish
        rts

UpdateSpritePosition
        ; 210 Y = (Y+VV) : X = (X+HV)
        LIBMATH_ADD16BIT_AAA LunaLanderYFrac, VerticalVelocityFrac, LunaLanderYFrac
        LIBMATH_ADD16BIT_AAA LunaLanderXFrac, HorizontalVelocityFrac, LunaLanderXFrac

        ;215 POKE 2041,TS : POKE 53250, XL : POKE 53251, Y
        ;216 POKE 53249, Y : POKE 53248,XL : POKE 53264, XH : REM CC=CC+1
        LIBSPRITE_SETFRAME_AA ThrustSpNo, ThrustFrameNo
        LIBSPRITE_SETFRAME_AA ManuoverSpNo, ManuoverFrameNo

        LIBSPRITE_SETPOSITION_AAAA LunaLanderSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ThrustSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ManuoverSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY

        rts

DidWeCollideWithScene
        LIBSPRITE_DIDCOLLIDEWITHDATA_A LunaLanderSpNo
        beq DidNotCollide
        ;lda #2
        ;sta EXTCOL
        lda #True
        sta CollidedWithBackground

        LIBSPRITE_SETCOLOR_AV     LunaLanderSpNo, Yellow
        LIBSPRITE_MULTICOLORENABLE_AV LunaLanderSpNo, True
        LIBSPRITE_PLAYANIM_AVVVV  LunaLanderSpNo, 5, 16, 3, False

DidNotCollide
        rts

UpdateBarsAndGauges
        lda VerticalVelocityFrac
        sta VerticalBarValue
        lda VerticalVelocity
        lsr 
        ror VerticalBarValue
        lsr 
        ror VerticalBarValue
        lsr 
        ror VerticalBarValue
        lda VerticalBarValue
        eor #$FF
        LIBBARSANDGAUGES_SHOWYBAR_AV $044E, $2C

        lda FuelBarValue
        LIBBARSANDGAUGES_SHOWYGAUGE_AV $044D, $00

        rts

AddFuelConsumption
        LIBMATH_ADD16BIT_AAA FuelBarValueFrac, ThrustCostFrac, FuelBarValueFrac
        rts
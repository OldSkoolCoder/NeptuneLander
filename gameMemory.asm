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

VerticalVelocityFracLo
        brk

VerticalVelocityFracHi
        brk

VerticalVelocity
        brk

GravityFracLo
        brk

GravityFracHi
        brk

Gravity
        brk

ThrustFracLo
        brk

ThrustFracHi
        brk

Thrust
        brk

HorizontalVelocityFrac
        brk

HorizontalVelocity
        brk

HorizontalVelocityHi
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

GameStatus
        brk

DemoMode
        BYTE 0          ; 0 = Game Mode / 255 = Demo Mode

DemoIncrement
        BYTE 1

DemoIncrementHi
        brk

GameLevel
        byte 0

GameDifficulty
        byte 0  ; 0 = Easy, 1 = Normal, 2 = Hard

FuelTankSize
        byte 0

LandingPadOneXStart
        word 0

LandingPadOneXFinish
        word 0

LandingPadOneYStart
        byte 0

LandingPadOneYFinish
        byte 0

LandingPadTwoXStart
        word 0

LandingPadTwoXFinish
        word 0

LandingPadTwoYStart
        byte 0

LandingPadTwoYFinish
        byte 0

LandingPadThreeXStart
        word 0

LandingPadThreeXFinish
        word 0

LandingPadThreeYStart
        byte 0

LandingPadThreeYFinish
        byte 0

LandScapeLocation
        word 0

LunaLanderWindowSpNo
        byte 3

LunaLanderWindowCol
        byte 1

ScoreMultiplierPad1
        byte 0

ScoreMultiplierPad2
        byte 0

ScoreMultiplierPad3
        byte 0

ScoreBoard
        byte 0

ScoreBoardThousands
        byte 0

ScoreBoardHundredThousands
        byte 0

LandingPadNumber
        byte 0


        ;80 VV = 0 : G = 3/112 : T = 3/112 : HV = 0 : HI = 1/28
gmSetUpGameVariables
        ; X = Level, Y = Difficulty
        ; Get Level Data Location

        stx GameLevel
        sty GameDifficulty

        txa
        asl     ; Multiply * 2
        tax

        lda gmLevelArray,x
        sta ZeroPageLow
        lda gmLevelArray + 1,x
        sta ZeroPageHigh

        ; Get Difiiculty Level Location
        lda GameDifficulty
        asl     ; Multiply * 2
        tay

        lda (ZeroPageLow),y
        sta ZeroPageLow2
        iny
        lda (ZeroPageLow),y
        sta ZeroPageHigh2
        
        ldy #0
        lda (ZeroPageLow2),y
        sta GravityFracLo
        iny
        lda (ZeroPageLow2),y
        sta GravityFracHi
        iny
        lda (ZeroPageLow2),y
        sta Gravity

        iny
        lda (ZeroPageLow2),y
        sta ThrustFracLo
        iny
        lda (ZeroPageLow2),y
        sta ThrustFracHi
        iny
        lda (ZeroPageLow2),y
        sta Thrust

        iny
        lda (ZeroPageLow2),y
        sta ThrustCostFrac
        iny
        lda (ZeroPageLow2),y
        sta ThrustCost

        iny
        lda (ZeroPageLow2),y
        sta ScoreMultiplierPad1
        iny
        lda (ZeroPageLow2),y
        sta ScoreMultiplierPad2
        iny
        lda (ZeroPageLow2),y
        sta ScoreMultiplierPad3

        iny
        lda (ZeroPageLow2),y
        sta HorizontalInertiaFrac
        iny
        lda (ZeroPageLow2),y
        sta HorizontalInertia

        iny
        lda (ZeroPageLow2),y
        sta FuelTankSize
        
        iny
        lda (ZeroPageLow2),y
        sta LandingPadOneXStart
        iny
        lda (ZeroPageLow2),y
        sta LandingPadOneXStart + 1

        iny
        lda (ZeroPageLow2),y
        sta LandingPadOneXFinish
        iny
        lda (ZeroPageLow2),y
        sta LandingPadOneXFinish + 1

        iny
        lda (ZeroPageLow2),y
        sta LandingPadOneYStart
        iny
        lda (ZeroPageLow2),y
        sta LandingPadOneYFinish

        iny
        lda (ZeroPageLow2),y
        sta LandingPadTwoXStart
        iny
        lda (ZeroPageLow2),y
        sta LandingPadTwoXStart + 1

        iny
        lda (ZeroPageLow2),y
        sta LandingPadTwoXFinish
        iny
        lda (ZeroPageLow2),y
        sta LandingPadTwoXFinish + 1

        iny
        lda (ZeroPageLow2),y
        sta LandingPadTwoYStart
        iny
        lda (ZeroPageLow2),y
        sta LandingPadTwoYFinish

        iny
        lda (ZeroPageLow2),y
        sta LandingPadThreeXStart
        iny
        lda (ZeroPageLow2),y
        sta LandingPadThreeXStart + 1

        iny
        lda (ZeroPageLow2),y
        sta LandingPadThreeXFinish
        iny
        lda (ZeroPageLow2),y
        sta LandingPadThreeXFinish + 1

        iny
        lda (ZeroPageLow2),y
        sta LandingPadThreeYStart
        iny
        lda (ZeroPageLow2),y
        sta LandingPadThreeYFinish

        iny
        lda (ZeroPageLow2),y
        sta LandScapeLocation
        iny
        lda (ZeroPageLow2),y
        sta LandScapeLocation + 1

        ldy LandScapeLocation + 1
        lda LandScapeLocation
        jsr $AB1E
        ;LIBPRINT_PRINTSTRING_A LandScapeLocation

;        lda #0
;        sta VerticalVelocity
;        sta HorizontalVelocity
;        sta Gravity
;        sta Thrust
;        sta HorizontalInertia
;        lda #False
;        sta CollidedWithBackground

;        lda #2
;        sta GravityFrac
;        lda #4
;        sta ThrustFrac
;        lda #2
;        sta HorizontalInertiaFrac

        lda #8
        sta FuelBarValueFrac
        lda #0
        sta FuelBarValue
        lda #GF_InFlight
        sta GameStatus

        lda #0
        sta LunaLanderXFrac
        sta LunaLanderYFrac
        sta VerticalVelocityFracLo
        sta VerticalVelocityFracHi
        sta VerticalVelocity
        sta HorizontalVelocityFrac
        sta HorizontalVelocity
        sta HorizontalVelocityHi
        sta LandingPadNumber

        rts

gmAddFuelConsumption
        LIBMATH_ADD16BIT_AAA FuelBarValueFrac, ThrustCostFrac, FuelBarValueFrac
        rts

gmSetUpCustomCharacters
        LIBSCREEN_SETCHARMEMORY 12
        rts

gmSetUpScoringDisplay
    ldy #>txtCurrentScore
    lda #<txtCurrentScore
    jsr $AB1E

    ;LIBSCORING_DISPLAYSCORE_AA ScoreBoard, scDisplayScoringLocation
    LIBSCORING_DISPLAYSCORESET_AA ScoreBoard + 2, scDisplayScoringLocationH
    LIBSCORING_DISPLAYSCORESET_AA ScoreBoard + 1, scDisplayScoringLocationM
    LIBSCORING_DISPLAYSCORESET_AA ScoreBoard, scDisplayScoringLocationL
    rts

gmLevelArray
    word gmLevelOneArray
    ;word gmLevelTwoArray
    ;word gmLevelThreeArray

gmLevelOneArray
    word @LevelEasy
    word @LevelNormal
    ;word @LevelHard

@LevelEasy
    byte 0,1,0    ; Gravity Frac, Gravity
    byte 0,4,0    ; Thrust Frac, Thrust
    byte 4,0    ; ThrustCost Frac, ThrustCost
    byte 10,5,2  ; Landing Pad Multipliers
    byte 2,0    ; Horizontal Inertia
    byte 95     ; Fuel Tank Size
    byte $3F,0    ; Pad One Start X
    byte $42,0    ; Pad One Finish X
    byte $E4      ; Pad One Start Y
    byte $E4      ; Pad One Finish Y
    byte $8C,0    ; Pad Two Start X
    byte $91,0    ; Pad Two Finish X
    byte $84      ; Pad Two Start Y
    byte $84      ; Pad Two Finish Y
    byte $08,$01    ; Pad Three Start X
    byte $11,$01    ; Pad Three Finish X
    byte $CC      ; Pad Three Start Y
    byte $CC      ; Pad Three Finish Y
    word @LevelEasyLandscape

@LevelEasyLandscape
    TEXT "{white}{clear}{down*8}GG{down}BC{down}D{down}H{down}{left}J{down}H{down}{left}J{down}{left}I{down}{left}K{down}{left*2}E{down}{left*3}{sh asterisk}A{down}{left*3}E{down}{left*2}E{down}{left}D{down}D{down}D{down}DLLLK{up}{left}I"
    TEXT "{up}{left}J{up}{left}H{up}{left}E{up}E{up}{sh asterisk}A{up}E{up}K{up}{left}I{up}K{up}{left}I{up}LLLK{up}{left}I{up}{left}D{up}{left*2}D{up}{left}{sh asterisk}A{up}E{up}K{up}{left}I{up}F{down}DGG{down}H{down}{left}J{down}H{down}{left}J"
    TEXT "{down}{left}I{down}{left}K{down}{left}H{down}{left}J{down}H{down}{left}J{down}{left}E{down}{left*2}E{down}{left}H{down}{left}J{down}D{down}BCLLLLEBC{down}BC{down}D"
    BYTE 0

@LevelNormal
    byte 0,2,0    ; Gravity Frac, Gravity
    byte 0,4,0    ; Thrust Frac, Thrust
    byte 64,0    ; ThrustCost Frac, ThrustCost
    byte 10,5,2  ; Landing Pad Multipliers
    byte 2,0    ; Horizontal Inertia
    byte 95     ; Fuel Tank Size
    byte $3F,0    ; Pad One Start X
    byte $42,0    ; Pad One Finish X
    byte $E4      ; Pad One Start Y
    byte $E4      ; Pad One Finish Y
    byte $8C,0    ; Pad Two Start X
    byte $91,0    ; Pad Two Finish X
    byte $84      ; Pad Two Start Y
    byte $84      ; Pad Two Finish Y
    byte $08,$01    ; Pad Three Start X
    byte $11,$01    ; Pad Three Finish X
    byte $CC      ; Pad Three Start Y
    byte $CC      ; Pad Three Finish Y
    word @LevelNormalLandscape

@LevelNormalLandscape
    TEXT "{white}{clear}{down*8}gg{down}bc{down}d{down}h{down}{left}j{down}h{down}{left}j{down}{left}i{down}{left}k{down}{left*2}e{down}{left*3}@a{down}{left*3}e{down}{left*2}e{down}{left}d{down}d{down}d{down}dlllk{up}{left}i"
    TEXT "{up}{left}j{up}{left}h{up}{left}e{up}e{up}@a{up}e{up}k{up}{left}i{up}k{up}{left}i{up}lllk{up}{left}i{up}{left}d{up}{left*2}d{up}{left}@a{up}e{up}k{up}{left}i{up}f{down}dgg{down}h{down}{left}j{down}h{down}{left}j"
    TEXT "{down}{left}i{down}{left}k{down}{left}h{down}{left}j{down}h{down}{left}j{down}{left}e{down}{left*2}e{down}{left}h{down}{left}j{down}d{down}bcllllebc{down}bc{down}d"
    BYTE 0

@LevelHard
    byte 0,0,0    ; Gravity Frac, Gravity
    byte 0,0,0    ; Thrust Frac, Thrust
    byte 0,0    ; ThrustCost Frac, ThrustCost
    byte 0,0,0  ; Landing Pad Multipliers
    byte 0,0    ; Horizontal Inertia
    byte 0     ; Fuel Tank Size
    byte 0,0    ; Pad One Start X
    byte 0,0    ; Pad One Finish X
    byte 0      ; Pad One Start Y
    byte 0      ; Pad One Finish Y
    byte 0,0    ; Pad Two Start X
    byte 0,0    ; Pad Two Finish X
    byte 0      ; Pad Two Start Y
    byte 0      ; Pad Two Finish Y
    byte 0,0    ; Pad Three Start X
    byte 0,0    ; Pad Three Finish X
    byte 0      ; Pad Three Start Y
    byte 0      ; Pad Three Finish Y
    word @LevelHardLandscape

@LevelHardLandscape
    TEXT "{white}{clear}{down*8}gg{down}bc{down}d{down}h{down}{left}j{down}h{down}{left}j{down}{left}i{down}{left}k{down}{left*2}e{down}{left*3}@a{down}{left*3}e{down}{left*2}e{down}{left}d{down}d{down}d{down}dlllk{up}{left}i"
    TEXT "{up}{left}j{up}{left}h{up}{left}e{up}e{up}@a{up}e{up}k{up}{left}i{up}k{up}{left}i{up}lllk{up}{left}i{up}{left}d{up}{left*2}d{up}{left}@a{up}e{up}k{up}{left}i{up}f{down}dgg{down}h{down}{left}j{down}h{down}{left}j"
    TEXT "{down}{left}i{down}{left}k{down}{left}h{down}{left}j{down}h{down}{left}j{down}{left}e{down}{left*2}e{down}{left}h{down}{left}j{down}d{down}bcllllebc{down}bc{down}d"
    BYTE 0

txtCurrentScore
    text "{home}{down*24}{right*12}{white}score :{up}"
    byte 0

txtPrepareToLandCaptain
    text "{home}{down*23}{right*5}{yellow}prepare to land, not much fuel"
    byte 0

txtHoustonTheEagleHasLanded
    text "{home}{down*23}{right*6}{yellow}huston, the eagle has landed"
    byte 0

txtCaptainImAfraidWeDidNotMakeIt
    text "{home}{down*21}{right*6}{yellow}eagle, come in eagle, eagle!{down*2}{left*27}press fire to start again!"
    byte 0

txtNeptuneLanderTitle1
    text "{home}{down*4}{right*4}n{down*2}{left}e{down*2}{left}p{down*2}{left}t{down*2}{left}u{down*2}{left}n{down*2}{left}e{down*2}{left}"
    byte 0

txtNeptuneLanderTitle2
    text "{home}{down*5}{right*35}l{down*2}{left}a{down*2}{left}n{down*2}{left}d{down*2}{left}e{down*2}{left}r{down*2}{left}"
    byte 0

txtNeptuneLanderTitle3
    text "{home}{down*23}{right*10}{yellow}press fire to start"
    byte 0



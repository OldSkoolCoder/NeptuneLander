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

SpriteShipNo
        byte 0

SpriteWindowShipNo
        byte 0

SpriteThrustNo
        byte 0

SpriteThrustRightNo
        byte 0

SpriteThrustLeftNo
        byte 0

TitleMusicSet
        byte 0

PlayMusicSet
        byte 0

MaxSafeLandingSpeed
        byte 0

NumberOfSuccessfulLandings
        byte 0

DontResetFuel
        byte 0


        ;80 VV = 0 : G = 3/112 : T = 3/112 : HV = 0 : HI = 1/28
gmSetUpGameVariables
        ; X = Level, Y = Difficulty
        ; Get Level Data Location

        stx GameLevel
        txa
        pha
        sty GameDifficulty

        tya
        asl     ; Multiply * 2
        tax

        lda gmDifficultyArray,x
        sta ZeroPageLow2
        lda gmDifficultyArray + 1,x
        sta ZeroPageHigh2

        ldy #0
        lda (ZeroPageLow2),y            ; Gravity FracLo
        sta GravityFracLo
        iny
        lda (ZeroPageLow2),y            ; Gravity FracHi
        sta GravityFracHi               
        iny
        lda (ZeroPageLow2),y            ; Gravity
        sta Gravity                     

        iny
        lda (ZeroPageLow2),y            ; Thrust FracLo 
        sta ThrustFracLo
        iny
        lda (ZeroPageLow2),y            ; Thrust FracHi
        sta ThrustFracHi
        iny
        lda (ZeroPageLow2),y            ; Thrust
        sta Thrust

        iny
        lda (ZeroPageLow2),y            ; Thrust Cost Frac
        sta ThrustCostFrac
        iny
        lda (ZeroPageLow2),y            ; Thrust Cost
        sta ThrustCost

        iny
        lda (ZeroPageLow2),y            ; Multiplier Pad 1
        sta ScoreMultiplierPad1         
        iny
        lda (ZeroPageLow2),y            ; Multiplier Pad 2
        sta ScoreMultiplierPad2
        iny
        lda (ZeroPageLow2),y            ; Multiplier Pad 3
        sta ScoreMultiplierPad3

        iny
        lda (ZeroPageLow2),y            ; Horizontal Interia Frac
        sta HorizontalInertiaFrac
        iny
        lda (ZeroPageLow2),y            ; Horizontal Interia
        sta HorizontalInertia

        iny
        lda (ZeroPageLow2),y            ; Fuel Tank Size
        sta FuelTankSize

        iny
        lda (ZeroPageLow2),y            ; Ship Sprite No
        sta SpriteShipNo
        iny
        lda (ZeroPageLow2),y            ; Ship Window No
        sta SpriteWindowShipNo
        iny
        lda (ZeroPageLow2),y            ; Ship Thrust No
        sta SpriteThrustNo
        iny
        lda (ZeroPageLow2),y            ; Ship Thrust Left
        sta SpriteThrustLeftNo
        iny
        lda (ZeroPageLow2),y            ; ShipThrust Right
        sta SpriteThrustRightNo

        iny
        lda (ZeroPageLow2),y            ; Max Safe Landing Speed
        sta MaxSafeLandingSpeed


        pla
        asl                 ; Multiply By 2
        tax
        lda gmLevelArray,x
        sta ZeroPageLow2
        lda gmLevelArray + 1,x
        sta ZeroPageHigh2

        ldy #0
        lda (ZeroPageLow2),y            ; Pad 1 Landing X Start
        sta LandingPadOneXStart
        iny
        lda (ZeroPageLow2),y
        sta LandingPadOneXStart + 1

        iny
        lda (ZeroPageLow2),y            ; Pad 1 Landing X Finish
        sta LandingPadOneXFinish        
        iny
        lda (ZeroPageLow2),y
        sta LandingPadOneXFinish + 1

        iny
        lda (ZeroPageLow2),y            ; Pad 1 Landing Y Start
        sta LandingPadOneYStart
        iny
        lda (ZeroPageLow2),y            ; Pad 1 Landing Y Finish
        sta LandingPadOneYFinish

        iny
        lda (ZeroPageLow2),y
        sta LandingPadTwoXStart         ; Pad 2 Landing X Start
        iny
        lda (ZeroPageLow2),y
        sta LandingPadTwoXStart + 1

        iny
        lda (ZeroPageLow2),y
        sta LandingPadTwoXFinish        ; Pad 2 Landing X Finish
        iny
        lda (ZeroPageLow2),y
        sta LandingPadTwoXFinish + 1

        iny
        lda (ZeroPageLow2),y            ; Pad 2 Landing Y Start
        sta LandingPadTwoYStart
        iny
        lda (ZeroPageLow2),y            ; Pad 2 Landing Y Finish
        sta LandingPadTwoYFinish

        iny
        lda (ZeroPageLow2),y            ; Pad 3 Landing X Start
        sta LandingPadThreeXStart
        iny
        lda (ZeroPageLow2),y
        sta LandingPadThreeXStart + 1

        iny
        lda (ZeroPageLow2),y            ; Pad 3 Landing X Finish
        sta LandingPadThreeXFinish
        iny
        lda (ZeroPageLow2),y
        sta LandingPadThreeXFinish + 1

        iny
        lda (ZeroPageLow2),y            ; Pad 3 Landing Y Start
        sta LandingPadThreeYStart
        iny
        lda (ZeroPageLow2),y            ; Pad 3 Landing Y Finish
        sta LandingPadThreeYFinish

        iny
        lda (ZeroPageLow2),y            ; Level Landscape Lo Byte
        sta LandScapeLocation
        iny
        lda (ZeroPageLow2),y            ; Level Landscape Hi Byte
        sta LandScapeLocation + 1

        tya
        pha

        lda #$93
        jsr krljmp_CHROUT$

        ldy LandScapeLocation + 1
        lda LandScapeLocation
        jsr libScreen_CopyMap

        pla
        tay

        iny
        lda (ZeroPageLow2),y
        sta ZeroPageParam5          ; X 

        iny
        lda (ZeroPageLow2),y
        sta ZeroPageParam6          ; Y

        iny
        lda (ZeroPageLow2),y
        sta ZeroPageParam7          ; How Many

        tya
        pha
        lda #Red
        jsr libScreen_SetColour
        pla
        tay

        iny
        lda (ZeroPageLow2),y
        sta ZeroPageParam5          ; X 

        iny
        lda (ZeroPageLow2),y
        sta ZeroPageParam6          ; Y

        iny
        lda (ZeroPageLow2),y
        sta ZeroPageParam7          ; How Many

        tya
        pha
        lda #Red
        jsr libScreen_SetColour
        pla
        tay

        iny
        lda (ZeroPageLow2),y
        sta ZeroPageParam5          ; X 

        iny
        lda (ZeroPageLow2),y
        sta ZeroPageParam6          ; Y

        iny
        lda (ZeroPageLow2),y
        sta ZeroPageParam7          ; How Many

        tya
        pha
        lda #Red
        jsr libScreen_SetColour
        pla
        tay

        ;jsr libPrint_PrintString
        ;jsr $AB1E
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

        lda #0
        sta LandingPadNumber

        lda DontResetFuel
        cmp #True
        beq @ByPassFuel
        lda #8
        sta FuelBarValueFrac
        lda #0
        sta FuelBarValue
@ByPassFuel
        lda #GF_InFlight
        sta GameStatus

gmResetGameVelocityValues
        lda #0
        sta LunaLanderXFrac
        sta LunaLanderYFrac
        sta VerticalVelocityFracLo
        sta VerticalVelocityFracHi
        sta VerticalVelocity
        sta HorizontalVelocityFrac
        sta HorizontalVelocity
        sta HorizontalVelocityHi

        rts

gmAddFuelConsumption
        LIBMATH_ADD16BIT_AAA FuelBarValueFrac, ThrustCostFrac, FuelBarValueFrac
        rts

gmSetUpCustomCharacters
        LIBSCREEN_SETCHARMEMORY 14
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
    word gmLevel1Array
    word gmLevel2Array
    word gmLevel3Array

gmDifficultyArray
    word gmDifficultyEasy
    word gmDifficultyNormal
    word gmDifficultyHard

gmLevel1Array
    byte 57,0    ; Pad One Start X
    byte 70,0    ; Pad One Finish X
    byte 219      ; Pad One Start Y
    byte 220      ; Pad One Finish Y
    byte 135,0    ; Pad Two Start X
    byte 150,0    ; Pad Two Finish X
    byte 123      ; Pad Two Start Y
    byte 124      ; Pad Two Finish Y
    byte $01,$01    ; Pad Three Start X (257)
    byte $17,$01    ; Pad Three Finish X (279)
    byte 195      ; Pad Three Start Y
    byte 195      ; Pad Three Finish Y
    word gmLevelOneLandscape
    byte 30,20,4    ; Pad 1 X, Y, Length
    byte 15,11,3    ; Pad 2 X, Y, Length
    byte 5,23,3    ; Pad 3 X, Y, Length

gmLevel2Array
    byte 68,0    ; Pad One Start X
    byte 87,0    ; Pad One Finish X
    byte 211      ; Pad One Start Y
    byte 212      ; Pad One Finish Y
    byte 145,0    ; Pad Two Start X
    byte 159,0    ; Pad Two Finish X
    byte 123      ; Pad Two Start Y
    byte 124      ; Pad Two Finish Y
    byte $11,$01    ; Pad Three Start X
    byte $28,$01    ; Pad Three Finish X
    byte 139      ; Pad Three Start Y
    byte 140      ; Pad Three Finish Y
    word gmLevelTwoLandscape
    byte 7,22,3    ; Pad 1 X, Y, Length
    byte 16,11,3    ; Pad 2 X, Y, Length
    byte 32,13,4    ; Pad 3 X, Y, Length

gmLevel3Array
    byte 49,0    ; Pad One Start X
    byte 70,0    ; Pad One Finish X
    byte 219      ; Pad One Start Y
    byte 220      ; Pad One Finish Y
    byte 137,0    ; Pad Two Start X
    byte 151,0    ; Pad Two Finish X
    byte 123      ; Pad Two Start Y
    byte 124      ; Pad Two Finish Y
    byte 185,0    ; Pad Three Start X
    byte 205,0    ; Pad Three Finish X
    byte 203      ; Pad Three Start Y
    byte 204      ; Pad Three Finish Y
    word gmLevelThreeLandscape
    byte 4,23,4    ; Pad 1 X, Y, Length
    byte 15,11,3    ; Pad 2 X, Y, Length
    byte 21,21,4    ; Pad 3 X, Y, Length

gmDifficultyEasy
    byte 0,1,0    ; Gravity Frac, Gravity
    byte 0,4,0    ; Thrust Frac, Thrust
    byte 4,0    ; ThrustCost Frac, ThrustCost
    byte 10,5,2  ; Landing Pad Multipliers
    byte 2,0    ; Horizontal Inertia
    byte 95     ; Fuel Tank Size
    byte 19      ; Ship SpriteNo
    byte 27     ; Ship Window No
    byte 20     ; Thrust No
    byte 22     ; Thrust Left
    byte 21     ; Thrust Right
    byte 16     ; Safe Landing Speed Max

gmDifficultyNormal
    byte 0,2,0    ; Gravity Frac, Gravity
    byte 0,4,0    ; Thrust Frac, Thrust
    byte 32,0    ; ThrustCost Frac, ThrustCost
    byte 10,5,2  ; Landing Pad Multipliers
    byte 2,0    ; Horizontal Inertia
    byte 95     ; Fuel Tank Size
    byte 23      ; Ship SpriteNo
    byte 28     ; Ship Window No
    byte 24     ; Thrust No
    byte 26     ; Thrust Left
    byte 25     ; Thrust Right
    byte 16     ; Safe Landing Speed Max

gmDifficultyHard
    byte 0,2,0    ; Gravity Frac, Gravity
    byte 0,4,0    ; Thrust Frac, Thrust
    byte 64,0    ; ThrustCost Frac, ThrustCost
    byte 10,5,2  ; Landing Pad Multipliers
    byte 2,0    ; Horizontal Inertia
    byte 95     ; Fuel Tank Size
    byte 0      ; Ship SpriteNo
    byte 18     ; Ship Window No
    byte 2     ; Thrust No
    byte 4     ; Thrust Left
    byte 3     ; Thrust Right
    byte 8     ; Safe Landing Speed Max

txtCurrentScore
    text "{home}{down*24}{right*12}{white}score :{up}"
    byte 0

txtPrepareToLandCaptain
    text "{home}{down*23}{right*5}{yellow}prepare to land, not much fuel{white}"
    byte 0

txtHoustonTheEagleHasLanded
    text "{home}{down*23}{right*6}{yellow}huston, the eagle has landed{white}"
    byte 0

txtCaptainImAfraidWeDidNotMakeIt
    text "{home}{down*21}{right*6}{yellow}eagle, come in eagle, eagle!{down*2}{left*27}press fire to start again!"
    byte 0

txtNeptuneLanderTitle1
    text "{home}{down*4}{right*4}n{down*2}{left}e{down*2}{left}p{down*2}{left}t{down*2}{left}u{down*2}{left}n{down*2}{left}e{down*2}{left}{white}"
    byte 0

txtNeptuneLanderTitle2
    text "{home}{down*5}{right*35}l{down*2}{left}a{down*2}{left}n{down*2}{left}d{down*2}{left}e{down*2}{left}r{down*2}{left}{white}"
    byte 0

txtNeptuneLanderTitle3
    text "{home}{down*23}{right*10}{yellow}press fire to start{white}"
    byte 0

txtWhichDifficultyLevel
    text "{clear}{down*10}"
    text "{right*4} easy (e){return}{down}"
    text "{right*4} normal (n){return}{down}"
    text "{right*4} hard (h){return}{down}"
    text "{right*4} please select difficulty e/n/h?"
    byte 0

txtLevelNotification
    text "{home}{down*5}{right*15}level : 00"
    byte 0

txtLostInSpace
    text "{home}{yellow}{down*5}{right*12}danger, danger,{return}{right*8}they are lost in space."
    byte 0

;@LevelOneEasyLandscape
;    TEXT "{white}{clear}{down*7}GG{down}{left*2}XXBC{down}{left*4}XXXXD{down}{left*5}{X*5}H{down}{left*6}{X*5}J{down}{left*6}{X*6}H"
;    TEXT "{down}{left*7}{X*6}J{down}{left*7}{X*6}I{down}{left*7}{X*6}K{down}{left*7}{X*5}E{down}{left*6}XXX{sh asterisk}A"
;    TEXT "{down}{left*5}XXE{down}{left*3}XE{down}{left*2}XD{down}{left*2}XXD{down}{left*3}XXXD"
;    TEXT "{down}{left*4}XXXXD{red}LLL{white}{down}{left*8}{X*5}{red}WWW{white}{X*3}{up}{left*3}V{X*2}{up}{left*3}U{X*10}"
;    TEXT "{up}{left*11}T{X*10}{up}{left*11}S{X*10}{up}{left*11}P{X*10}{up}{left*10}P{X*9}{up}{left*9}RQ{X*7}{up}{left*7}P{X*6}"
;    TEXT "{up}{left*6}O{X*5}{up}{left*6}N{X*5}{up}{left*5}OXXXX{up}{left*5}N{red}WWW{white}{X*8}{up}{left*11}{red}LLL{white}O{X*7}"
;    TEXT "{up}{left*8}N{X*7}{up}{left*8}M{X*7}{up}{left*9}M{X*8}{up}{left*9}RQ{X*7}{up}{left*7}P{X*5}{up}{left*5}OXXXX{up}{left*5}NX{up}{left}F"
;    TEXT "{down}DGG{down}H{down}{left}J{down}H{down}{left}J{down}{left}I{down}{left}K{down}{left}H{down}{left}J{down}{left*8}{X*8}H{down}{left*9}{X*8}J"
;    TEXT "{down}{left*9}{X*8}E{down}{left*9}{X*7}E{down}{left*8}{X*7}H{down}{left*8}{X*7}J{down}{left*8}{X*8}D{down}{left*9}{X*9}BC{red}LLLL{white}PBC"
;    TEXT "{down}{left*18}{X*11}{red}WWWW{white}XXXBC{down}{left*20}{X*20}D{down}{left*13}{X*13}{left*13}{down}{X*12}"
;    BYTE 0

;@LevelOneEasyLandscape
;    TEXT "{white}{clear}{down*7}GG{down}BC{down}D{down}H{down}{left}J{down}H{down}{left}J{down}{left}I{down}{left}K{down}{left*2}E{down}{left*3}{sh asterisk}A{down}{left*3}E{down}{left*2}E{down}{left}D{down}D{down}D{down}DLLL{down}{left*3}WWW{up}V{up}{left}U"
;    TEXT "{up}{left}T{up}{left}S{up}{left}P{up}P{up}RQ{up}P{up}O{up}{left}N{up}O{up}{left}NWWW{up}{left*3}LLLO{up}{left}N{up}{left}M{up}{left*2}M{up}{left}RQ{up}P{up}O{up}{left}N{up}F{down}DGG{down}H{down}{left}J{down}H{down}{left}J"
;    TEXT "{down}{left}I{down}{left}K{down}{left}H{down}{left}J{down}H{down}{left}J{down}{left}E{down}{left*2}E{down}{left}H{down}{left}J{down}D{down}BCLLLL{down}{left*4}WWWW{up}PBC{down}BC{down}D"
;    BYTE 0

;@LevelOneEasyLandscape
;    TEXT "{white}{clear}{down*7}GG{down}BC{down}D{down}H{down}{left}J{down}H{down}{left}J{down}{left}I{down}{left}K{down}{left*2}E{down}{left*3}{sh asterisk}A{down}{left*3}E{down}{left*2}E{down}{left}D{down}D{down}D{down}DLLLK{up}{left}I"
;    TEXT "{up}{left}J{up}{left}H{up}{left}E{up}E{up}{sh asterisk}A{up}E{up}K{up}{left}I{up}K{up}{left}I{up}LLLK{up}{left}I{up}{left}D{up}{left*2}D{up}{left}{sh asterisk}A{up}E{up}K{up}{left}I{up}F{down}DGG{down}H{down}{left}J{down}H{down}{left}J"
;    TEXT "{down}{left}I{down}{left}K{down}{left}H{down}{left}J{down}H{down}{left}J{down}{left}E{down}{left*2}E{down}{left}H{down}{left}J{down}D{down}BCLLLLEBC{down}BC{down}D"
;    BYTE 0



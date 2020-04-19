
gfStatusJumpTableLo
    BYTE <gfStatusMenu
    BYTE <gfStatusInFlight
    BYTE <gfStatusLanded
    BYTE <gfStatusDying
    BYTE <gfStatusDead
    BYTE <gfSetUpSplashScreen
    BYTE <gfGameRetry
    BYTE <gfNextLevel

gfStatusJumpTableHi
    BYTE >gfStatusMenu
    BYTE >gfStatusInFlight
    BYTE >gfStatusLanded
    BYTE >gfStatusDying
    BYTE >gfStatusDead
    BYTE >gfSetUpSplashScreen
    BYTE >gfGameRetry
    BYTE >gfNextLevel

;***********************************************************************
; Main Status Flow Routing Routine
gfUpdateGameFlow
    ldx GameStatus
    lda gfStatusJumpTableLo,x 
    sta ZeroPageLow
    lda gfStatusJumpTableHi,x
    sta ZeroPageHigh

    jmp (ZeroPageLow)

;***********************************************************************
; Game Menu Mode
gfStatusMenu
    rts

;***********************************************************************
; Normal Flight Mode, check of collision detection
gfStatusInFlight

    jsr gfHaveWeSafelyLanded
    bcc @SoFarNotLanded
    stx LandingPadNumber
    lda #GF_Landed
    sta GameStatus
    
@SoFarNotLanded
    jsr glDidWeCollideWithScene
    lda CollidedWithBackground
    cmp #False
    bne @SpriteCollided
    jmp gfNotCollided

;***********************************************************************
; Check Lander has not hit the status bars.
@SpriteCollided
    lda LunaLanderXHi
    cmp #1
    bne @ConfirmCollided

    lda LunaLanderXLo
    cmp #40
    bcs @ConfirmYBarStatus
    jmp @ConfirmCollided

@ConfirmYBarStatus
    lda LunaLanderY
    cmp #155
    bcc gfStatusInFlightOK
    ;jmp @ConfirmCollided

;***********************************************************************
; Confirmation Lander has collided with something
@ConfirmCollided
    lda #GF_Dying
    sta GameStatus

    ldx #spNoThrust
    stx ThrustFrameNo
    stx ManuoverFrameNo
    LIBSPRITE_SETFRAME_AA ThrustSpNo, ThrustFrameNo
    LIBSPRITE_SETFRAME_AA ManuoverSpNo, ManuoverFrameNo
    LIBSPRITE_SETFRAME_AA LunaLanderWindowSpNo, ThrustFrameNo

    LIBSPRITE_SETCOLOR_AV     LunaLanderSpNo, Yellow
    LIBSPRITE_MULTICOLORENABLE_AV LunaLanderSpNo, True
    LIBSPRITE_PLAYANIM_AVVVV  LunaLanderSpNo, 5, 16, 3, False

gfNotCollided
    rts

;**********************************************************************
; Flight Is Normnal, collision was a false positive
gfStatusInFlightOK
    lda #False
    sta CollidedWithBackground
    rts

;**********************************************************************
; Lander has successfully landed
gfStatusLanded
    lda #0
    sta LunaLanderXFrac
    sta LunaLanderYFrac
    sta VerticalVelocityFracLo
    sta VerticalVelocityFracHi
    sta VerticalVelocity
    sta HorizontalVelocityFrac
    sta HorizontalVelocity
    sta HorizontalVelocityHi

    ldy #>txtHoustonTheEagleHasLanded
    lda #<txtHoustonTheEagleHasLanded
    jsr $AB1E

    ldx LandingPadNumber
    dex
    lda ScoreMultiplierPad1,x 
    sta ZeroPageParam9      ; Scoring Multiplier

@FuelScoreLoop
    ;jsr gmAddFuelConsumption
    inc FuelBarValue
    lda FuelBarValue
    cmp FuelTankSize
    bcs @TankEmpty
    LIBSCORING_ADDSCORE_AA ZeroPageParam9, ScoreBoard

    LIBSCORING_DISPLAYSCORESET_AA ScoreBoard + 2, scDisplayScoringLocationH
    LIBSCORING_DISPLAYSCORESET_AA ScoreBoard + 1, scDisplayScoringLocationM
    LIBSCORING_DISPLAYSCORESET_AA ScoreBoard, scDisplayScoringLocationL
    rts
    
@TankEmpty
    lda #GF_NextLevel
    sta GameStatus
    rts
    ;jmp @TankEmpty
    

;**********************************************************************
; The Lander is currently dying (explosion animation)
gfStatusDying
    LIBSPRITE_ISANIMPLAYING_A LunaLanderSpNo
    bne @NotFinishedDying

    lda #GF_Dead
    sta GameStatus

@NotFinishedDying
    rts

;**********************************************************************
; Confirmation of Luna Death.
gfStatusDead
    ldy #>txtCaptainImAfraidWeDidNotMakeIt
    lda #<txtCaptainImAfraidWeDidNotMakeIt
    jsr $AB1E
    
    jsr libInputUpdate

    LIBINPUT_GETHELD GameportFireMask
    bne @NoGameReset

    LIBSPRITE_DIDCOLLIDEWITHDATA_A LunaLanderSpNo
    ;lda SPBGCL
    lda #False
    sta CollidedWithBackground

    ldx #0 ; Level 1
    ldy #0 ; Normal=1 / Easy=0 / Hard=2 Difficulty
    stx GameLevel
    sty GameDifficulty

    jsr glDisableSprites
    ;lda #GF_Retry
    ;sta GameStatus

    lda #GF_Title
    sta GameStatus

@NoGameReset
    rts

gfHaveWeSafelyLanded
;   Output X Reg = Landing Zone

;        lda LunaLanderXHi
;        clc
;        adc #$30
;        sta 1024
;        ldx LunaLanderXLo
;        stx 1025
;        ldx HorizontalVelocityHi
;        stx 1028
;        ldx HorizontalVelocity
;        stx 1027
;        ldx HorizontalVelocityFrac
;        stx 1026

    ldx #$00
    ;LIBLUNA_CHECKLANDINGSITE_VVV $0108, $0111, $CA
    LIBLUNA_CHECKLANDINGSITE_AAA LandingPadThreeXStart, LandingPadThreeXFinish, LandingPadThreeYStart
    bcc @TestSecondLandSite
    ldx #$03
    jmp gfWeHaveLanded
    
@TestSecondLandSite
    ;LIBLUNA_CHECKLANDINGSITE_VVV $008C, $0091, $84
    LIBLUNA_CHECKLANDINGSITE_AAA LandingPadTwoXStart, LandingPadTwoXFinish, LandingPadTwoYStart
    bcc @TestThirdLandSite
    ldx #$02
    jmp gfWeHaveLanded

@TestThirdLandSite
    ;LIBLUNA_CHECKLANDINGSITE_VVV $003F, $0042, $E4
    LIBLUNA_CHECKLANDINGSITE_AAA LandingPadOneXStart, LandingPadOneXFinish, LandingPadOneYStart
    bcc gfWeHaveLanded          ; Not Landed Legally
    ldx #$01
    jmp gfWeHaveLanded

gfWeHaveLanded
    rts

;**********************************************************************
; Neptune Lander Title Splash Screen
gfSetUpSplashScreen
    jsr gfScrollScreenDown
    lda #GF_Retry
    sta GameStatus
    rts

gfScrollScreenDown

    lda #$93
    jsr krljmp_CHROUT$

    clc
    lda #<SplashScreen
    adc #$e8
    sta ZeroPageLow
    lda #>SplashScreen
    adc #$03
    sta ZeroPageHigh

    clc
    lda #<SplashScreen
    adc #$D0
    sta ZeroPageLow2
    lda #>SplashScreen
    adc #$07
    sta ZeroPageHigh2

    LIBSCREEN_SCROLLYRESET_A gfPlaceNextRowOfAircraft
    LIBSCREEN_SET24ROWMODE

    lda #24
    sta screenRow

    lda #32
    sta ScrollLooper + 1

ScrollLooper
    ;LIBSCREEN_WAIT_V 255

    lda #128            ; Scanline -> A
    cmp RASTER          ; Compare A to current raster line
    bne ScrollLooper    ; Loop if raster line not reached 255

    LIBSCREEN_SCROLLYDOWN_A gfUpdateIntroScreen

    lda screenRow
    cmp #$FF
    beq @End
    inc ScrollLooper + 1
    jmp ScrollLooper

@End
    LIBSCREEN_SET25ROWMODE

    ldy #>txtNeptuneLanderTitle1
    lda #<txtNeptuneLanderTitle1
    jsr $AB1E

    ldy #>txtNeptuneLanderTitle2
    lda #<txtNeptuneLanderTitle2
    jsr $AB1E

    ldy #>txtNeptuneLanderTitle3
    lda #<txtNeptuneLanderTitle3
    jsr $AB1E

    jsr SetUpSIDPlayer

@ScanAgain
    jsr libInputUpdate

    LIBINPUT_GETHELD GameportFireMask
    bne @ScanAgain
    rts

gfPlaceNextRowOfAircraft

    sec
    lda ZeroPageLow
    sbc #40
    sta ZeroPageLow
    lda ZeroPageHigh
    sbc #$00
    sta ZeroPageHigh

    sec
    lda ZeroPageLow2
    sbc #40
    sta ZeroPageLow2
    lda ZeroPageHigh2
    sbc #$00
    sta ZeroPageHigh2

    ldy #0
@loop
    lda (ZeroPageLow),y
    sta COLORRAM,y
    lda (ZeroPageLow2),y
    sta SCREENRAM,y

    iny
    cpy #40
    bne @loop

    rts

gfUpdateIntroScreen

    ldy #23
@CharacterLoopSection4
    ; Last Section First


;    lda $07C0+ 8,y
;    sta $07E8+ 8,y

;    lda $DBC0+ 8,y
;    sta $DBE8+ 8,y

    lda $0798+ 8,y
    sta $07C0+ 8,y

    lda $DB98+ 8,y
    sta $DBC0+ 8,y

    lda $0770+ 8,y
    sta $0798+ 8,y

    lda $DB70+ 8,y
    sta $DB98+ 8,y

    lda $0748+ 8,y
    sta $0770+ 8,y

    lda $DB48+ 8,y
    sta $DB70+ 8,y

    lda $0720+ 8,y
    sta $0748+ 8,y

    lda $DB20+ 8,y
    sta $DB48+ 8,y

    lda $06F8+ 8,y
    sta $0720+ 8,y

    lda $DAF8+ 8,y
    sta $DB20+ 8,y

    lda $06D0+ 8,y
    sta $06F8+ 8,y

    lda $DAD0+ 8,y
    sta $DAF8+ 8,y

    lda $06A8+ 8,y
    sta $06D0+ 8,y

    lda $DAA8+ 8,y
    sta $DAD0+ 8,y

    lda $0680+ 8,y
    sta $06A8+ 8,y

    lda $DA80+ 8,y
    sta $DAA8+ 8,y

    lda $0658+ 8,y
    sta $0680+ 8,y

    lda $DA58+ 8,y
    sta $DA80+ 8,y

    lda $0630+ 8,y
    sta $0658+ 8,y

    lda $DA30+ 8,y
    sta $DA58+ 8,y

    lda $0608+ 8,y
    sta $0630+ 8,y

    lda $DA08+ 8,y
    sta $DA30+ 8,y

    lda $05E0+ 8,y
    sta $0608+ 8,y

    lda $D9E0+ 8,y
    sta $DA08+ 8,y

    lda $05B8+ 8,y
    sta $05E0+ 8,y

    lda $D9B8+ 8,y
    sta $D9E0+ 8,y

    lda $0590+ 8,y
    sta $05B8+ 8,y

    lda $D990+ 8,y
    sta $D9B8+ 8,y

    lda $0568+ 8,y
    sta $0590+ 8,y

    lda $D968+ 8,y
    sta $D990+ 8,y

    lda $0540+ 8,y
    sta $0568+ 8,y

    lda $D940+ 8,y
    sta $D968+ 8,y

    lda $0518+ 8,y
    sta $0540+ 8,y

    lda $D918+ 8,y
    sta $D940+ 8,y

    lda $04F0+ 8,y
    sta $0518+ 8,y

    lda $D8F0+ 8,y
    sta $D918+ 8,y

    lda $04C8+ 8,y
    sta $04F0+ 8,y

    lda $D8C8+ 8,y
    sta $D8F0+ 8,y

    lda $04A0+ 8,y
    sta $04C8+ 8,y

    lda $D8A0+ 8,y
    sta $D8C8+ 8,y

    lda $0478+ 8,y
    sta $04A0+ 8,y

    lda $D878+ 8,y
    sta $D8A0+ 8,y

    lda $0450+ 8,y
    sta $0478+ 8,y

    lda $D850+ 8,y
    sta $D878+ 8,y

    lda $0428+ 8,y
    sta $0450+ 8,y

    lda $D828+ 8,y
    sta $D850+ 8,y

    lda $0400+ 8,y
    sta $0428+ 8,y

    lda $D800+ 8,y
    sta $D828+ 8,y

    dey
    cpy #$FF
    beq @Done
    jmp @CharacterLoopSection4

@Done
    jmp gfPlaceNextRowOfAircraft

;**********************************************************************
; Confirmation of Game Retry.
gfGameRetry
    LIBSCREEN_SET25ROWMODE
    LIBSCREEN_SETSCROLLYVALUE_V 3
    jsr glDisableSprites
    jsr gfPrepareToLanderCaptain
    ldx GameLevel
    ldy GameDifficulty
    jsr glSetUpLunarSprite
    jsr gmSetUpGameVariables
    jsr gbSetUpFuelAndSpeedBars
    lda #0
    sta ScoreBoard
    sta ScoreBoard + 1
    sta ScoreBoard + 2
    jsr gmSetUpScoringDisplay
    rts

gfPrepareToLanderCaptain
    lda #$93
    jsr krljmp_CHROUT$

    ldy #>txtPrepareToLandCaptain
    lda #<txtPrepareToLandCaptain
    jsr $AB1E
    
    LIBINPUT_DELAY_V 255
    LIBINPUT_DELAY_V 255
    LIBINPUT_DELAY_V 255
    LIBINPUT_DELAY_V 255
    LIBINPUT_DELAY_V 255
    LIBINPUT_DELAY_V 255
    LIBINPUT_DELAY_V 255
    LIBINPUT_DELAY_V 255
    rts
;**********************************************************************
; Confirmation of Game Next Level.
gfNextLevel
    ldx GameLevel
    ldy GameDifficulty
    ;inx
    jsr glDisableSprites
    jsr gfPrepareToLanderCaptain
    jsr gmSetUpGameVariables
    jsr glSetUpLunarSprite
    jsr gbSetUpFuelAndSpeedBars
    jsr gmSetUpScoringDisplay
    rts

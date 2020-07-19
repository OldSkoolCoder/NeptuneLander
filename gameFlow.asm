;*************************************************************************
; Jump Table for different Game Modes
gfStatusJumpTableLo
    BYTE <gfStatusMenu
    BYTE <gfStatusInFlight
    BYTE <gfStatusLanded
    BYTE <gfStatusDying
    BYTE <gfStatusDead
    BYTE <gfSetUpSplashScreen
    BYTE <gfGameRetry
    BYTE <gfNextLevel
    BYTE <gfUpdateScore
    BYTE <gfInitialiseGame
    BYTE <gfDifficultyChoice
    BYTE <gfDiedButLetsTryAgain

gfStatusJumpTableHi
    BYTE >gfStatusMenu
    BYTE >gfStatusInFlight
    BYTE >gfStatusLanded
    BYTE >gfStatusDying
    BYTE >gfStatusDead
    BYTE >gfSetUpSplashScreen
    BYTE >gfGameRetry
    BYTE >gfNextLevel
    BYTE >gfUpdateScore
    BYTE >gfInitialiseGame
    BYTE >gfDifficultyChoice
    BYTE >gfDiedButLetsTryAgain

;***********************************************************************
; Main Status Flow Routing Routine
gfUpdateGameFlow
    ldx GameStatus              ; Load Game Mode
    lda gfStatusJumpTableLo,x   ; Get Low Jump Vector
    sta ZeroPageLow
    lda gfStatusJumpTableHi,x   ; Get Hi Jump Vector
    sta ZeroPageHigh

    jmp (ZeroPageLow)           ; Jump To Game Mode Routine

;**********************************************************************
; Initialise The Game for Playing
gfInitialiseGame
    LIBSCREEN_SETCOLORS Black, Black, Black, Black, Black

    jsr gmSetUpCustomCharacters
    jsr SetUpSIDPlayer

    ldx #0 ; Level 1
    ldy #0 ; Easy=0 / Normal=1 / Hard=2 .... Difficulty
    stx GameLevel
    sty GameDifficulty

    lda #GF_Title       ; Set Game Status To Title for next cycle
    sta GameStatus
    rts

;**********************************************************************
; Neptune Lander Title Splash Screen
gfSetUpSplashScreen
    jsr gsScrollScreenDown      ; Scroll in the Title screen
    lda #GF_Difficulty          ; Set game status to difficulty menu
    sta GameStatus
    rts

;**********************************************************************
; Initialise The Game for Playing
gfDifficultyChoice
    jsr gsPleaseSelectDifficulty    ; Print difficulty options

@gfKeyboardCheck
    lda LSTX                    ; load current key scan results
    cmp #scanCode_NO_KEY$       ; Check for No Key Pressed
    beq @gfKeyboardCheck        ; No Key was pressed

    cmp #scanCode_E$            ; Easy Mode (E)
    bne @gfKeyTryNormal
    ldx #GD_Easy
    jmp @gfDifficultySelected

@gfKeyTryNormal
    cmp #scanCode_N$            ; Normal Mode (N)
    bne @gfKeyTryHard
    ldx #GD_Normal
    jmp @gfDifficultySelected

@gfKeyTryHard
    cmp #scanCode_H$            ; Hard Mode (H)
    bne @gfKeyboardCheck
    ldx #GD_Hard

@gfDifficultySelected
    stx GameDifficulty

    lda #0                      ; Reset Loop Counter
    sta ZeroPageTemp

gfSelectionLooper
    ldx GameDifficulty
    txa
    asl     ; time by 2         ; because 2 lines per menu item

    clc
    adc #10                     ; add 10 as thats the start of the menu
    tax

    lda ColorRAMRowStartLow,x   ; Find start of address selected Row
    sta @gfDifficultyRow + 1

    lda ColorRAMRowStartHigh,x  ; Find start address of select row
    sta @gfDifficultyRow + 2
    
    ldy #39
    ldx #Green                  ; Load Green
    inc ZeroPageTemp            ; Increase loop counter
    lda ZeroPageTemp            
    and #1                      ; and with 1 which results in either 1 or 0
    bne @gfDifficultyRow -1     ; if 1 then leave green
    ldx #Red                    ; if zero change to red
    txa

@gfDifficultyRow
    sta $D800,y                 ; fill row with colour
    dey
    bpl @gfDifficultyRow

    LIBINPUT_DELAY_V 255        ; delay for a short while

    lda ZeroPageTemp
    cmp #7                      ; have we dont this 7 times ?
    beq @gfSelectionLooperEnd   ; Yup, right lets get out
    jmp gfSelectionLooper       ; Nope, right lets do this again

@gfSelectionLooperEnd
    lda #GF_Retry               ; Set Status to game retry.
    sta GameStatus

    rts

;***********************************************************************
; Game Menu Mode
gfStatusMenu
    rts

;***********************************************************************
; Normal Flight Mode, check of collision detection
gfStatusInFlight

    lda DemoMode                    ; Load Demo Indicator Flag
    cmp #255                        ; Demo Mode ?
    bne @gfNotInDemoMode              ; No
                                    ; Yes
    jsr glDebugReadInputAndUpdateVariables  ; Read Controls and Update
    jsr glUpdateSpritePosition      ; Update Sprite Position
    jsr glDidWeCollideWithScene     ; check for screen collision
    rts                             ; Return to Game Looper Routine

@gfNotInDemoMode
    jsr glReadInputAndUpdateVariables   ; Read Controls and Update
    jsr glUpdateSpritePosition      ; Update Sprites State

    jsr gbUpdateBarsAndGauges       ; Update Gauges and Bars

gfGameLooper
    jsr gfHaveWeSafelyLanded        ; check to see if we landed safely
    bcc @gfSoFarNotLanded             ; clear carry means no successful landing

    lda VerticalBarValue            ; load vertical velocity
    cmp #8                          ; withing the green area?
    bcc @gfLandedVelocityOK           ; Yes
    jmp @gfConfirmCollided            ; No, we crashed

@gfLandedVelocityOK
    stx LandingPadNumber            ; Record which Landing Pad
    lda #GF_Landed                  ; Change Game state to "Landed"
    sta GameStatus
    rts
    
@gfSoFarNotLanded
    jsr glDidWeCollideWithScene     ; have we colided with the scenry
    lda CollidedWithBackground      ; load collision flag
    cmp #False
    bne @gfSpriteCollided             ; Oh Dear, we crashed
    rts                             ; No crash

;***********************************************************************
; Check Lander has not hit the status bars.
@gfSpriteCollided
    lda LunaLanderXHi               ; have we hit the status bars
    cmp #1
    bne @gfConfirmCollided            ; Yes

    lda LunaLanderXLo               ; have we hit the status bars
    cmp #40
    bcs @gfConfirmYBarStatus          ; No
    jmp @gfConfirmCollided            ; Yes

@gfConfirmYBarStatus
    lda LunaLanderY                 ; check we are under the bars
    cmp #155
    bcc gfStatusInFlightOK          ; Flight is good

;***********************************************************************
; Confirmation Lander has collided with something
@gfConfirmCollided
    lda #GF_Dying                   ; Set game state to "Dying"
    sta GameStatus

    ldx #spNoThrust                 ; Reset Thrust Sprites to nothing
    stx ThrustFrameNo
    stx ManuoverFrameNo

    ; set up the sprites inital frames
    LIBSPRITE_SETFRAME_AA ThrustSpNo, ThrustFrameNo
    LIBSPRITE_SETFRAME_AA ManuoverSpNo, ManuoverFrameNo
    LIBSPRITE_SETFRAME_AA LunaLanderWindowSpNo, ThrustFrameNo

    ; start the animation of the explosion
    LIBSPRITE_SETCOLOR_AV     LunaLanderSpNo, Yellow
    LIBSPRITE_MULTICOLORENABLE_AV LunaLanderSpNo, True
    LIBSPRITE_PLAYANIM_AVVVV  LunaLanderSpNo, 5, 16, 3, False

gfNotCollided
    rts

;**********************************************************************
; Flight Is Normnal, collision was a false positive
gfStatusInFlightOK

    ; Rest Collison Flag
    lda #False
    sta CollidedWithBackground
    rts

;**********************************************************************
; Lander has successfully landed
gfStatusLanded
    jsr gmResetGameVelocityValues ; Reset The Game Velocities

    jsr gsTheEagleHasLanded       ; display the lander has landed

    lda #GF_UpdateScore          ; Update Scores
    sta GameStatus
    rts
    
;**********************************************************************
; The Lander has landed and now updating score animation
gfUpdateScore
    ldx LandingPadNumber
    dex
    lda ScoreMultiplierPad1,x 
    sta ZeroPageParam9      ; Scoring Multiplier

@FuelScoreLoop
    inc FuelBarValue
    lda FuelBarValue
    cmp FuelTankSize
    bcs @TankEmpty

    LIBSCORING_ADDSCORE_AA ZeroPageParam9, ScoreBoard

    LIBSCORING_DISPLAYSCORESET_AA ScoreBoard + 2, scDisplayScoringLocationH
    LIBSCORING_DISPLAYSCORESET_AA ScoreBoard + 1, scDisplayScoringLocationM
    LIBSCORING_DISPLAYSCORESET_AA ScoreBoard, scDisplayScoringLocationL

    jmp gbUpdateBarsAndGauges
    
@TankEmpty

    LIBINPUT_DELAY_V 255
    LIBINPUT_DELAY_V 255

    lda #GF_NextLevel
    sta GameStatus
    rts

;**********************************************************************
; The Lander is currently dying (explosion animation)
gfStatusDying
    LIBSPRITE_ISANIMPLAYING_A LunaLanderSpNo ; Start the Dying Animation
    bne @gfNotFinishedDying

    lda #GF_Dead            ; Update Dead
    sta GameStatus

@gfNotFinishedDying
    rts

;**********************************************************************
; Confirmation of Luna Death.
gfStatusDead
    ldy #>txtCaptainImAfraidWeDidNotMakeIt
    lda #<txtCaptainImAfraidWeDidNotMakeIt
    jsr $AB1E
    
    jsr libInputUpdate

    LIBINPUT_GETHELD GameportFireMask
    bne @gfNoGameReset

    LIBSPRITE_DIDCOLLIDEWITHDATA_A LunaLanderSpNo

    lda #False
    sta CollidedWithBackground

    jsr glDisableSprites

    lda FuelBarValue
    cmp FuelTankSize
    bne @gfStillFuelRemaining
    
    lda #GF_Title
    sta GameStatus
    jmp @gfNoGameReset

@gfStillFuelRemaining
    lda #GF_DiedSoTryAgain
    sta GameStatus

@gfNoGameReset
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
    LIBLUNA_CHECKLANDINGSITE_AAA LandingPadThreeXStart, LandingPadThreeXFinish, LandingPadThreeYStart
    bcc @gfTestSecondLandSite
    ldx #$03
    jmp gfWeHaveLanded
    
@gfTestSecondLandSite
    LIBLUNA_CHECKLANDINGSITE_AAA LandingPadTwoXStart, LandingPadTwoXFinish, LandingPadTwoYStart
    bcc @gfTestThirdLandSite
    ldx #$02
    jmp gfWeHaveLanded

@gfTestThirdLandSite
    LIBLUNA_CHECKLANDINGSITE_AAA LandingPadOneXStart, LandingPadOneXFinish, LandingPadOneYStart
    bcc gfWeHaveLanded          ; Not Landed Legally
    ldx #$01
    jmp gfWeHaveLanded

gfWeHaveLanded
    rts

;**********************************************************************
; Confirmation of Game Retry.
gfGameRetry
    LIBSCREEN_SET25ROWMODE
    LIBSCREEN_SETSCROLLYVALUE_V 3
    jsr glDisableSprites
    jsr gsPrepareToLanderCaptain
    jsr gsDisplayCurrentLevel
    ldx GameLevel
    ldy GameDifficulty
    jsr gmSetUpGameVariables
    jsr glSetUpLunarSprite
    jsr gbSetUpFuelAndSpeedBars
    lda #0
    sta ScoreBoard
    sta ScoreBoard + 1
    sta ScoreBoard + 2
    jsr gmSetUpScoringDisplay

    jsr glDidWeCollideWithScene ; Just in case we hit some words ;)
    lda #False
    sta CollidedWithBackground

    rts

;**********************************************************************
; Confirmation of Game Next Level.
gfNextLevel
    jsr glDisableSprites
    jsr gsPrepareToLanderCaptain
    inc NumberOfSuccessfulLandings
    lda NumberOfSuccessfulLandings
    cmp #3
    bne @StayOnSameLevel
    ldx GameLevel
    inx
    stx GameLevel
    lda #0
    sta NumberOfSuccessfulLandings
@StayOnSameLevel
    ldx GameLevel
    ldy GameDifficulty
    jsr gsDisplayCurrentLevel
    jsr gmSetUpGameVariables
    jsr glSetUpLunarSprite
    jsr gbSetUpFuelAndSpeedBars
    jsr gmSetUpScoringDisplay

    jsr glDidWeCollideWithScene ; Just in case we hit some words ;)
    lda #False
    sta CollidedWithBackground

    rts

;********************************************************
; Died, did we have fuel to try again
gfDiedButLetsTryAgain
    jsr glDisableSprites
    jsr gsPrepareToLanderCaptain
    jsr gsDisplayCurrentLevel
    ldx GameLevel
    ldy GameDifficulty
    lda #True
    sta DontResetFuel
    jsr gmSetUpGameVariables
    lda #False
    sta DontResetFuel
    jsr glSetUpLunarSprite
    jsr gbSetUpFuelAndSpeedBars
    jsr gmSetUpScoringDisplay

    lda #0
    sta ZeroPageParam4

gfTankEmptier
    lda ZeroPageParam4
    cmp FuelBarValue
    bcs gfTankEmptied
    inc ZeroPageParam4 

    lda ZeroPageParam4
    LIBBARSANDGAUGES_SHOWYGAUGE_AV $044D, $00
    jmp gfTankEmptier

gfTankEmptied
    jsr glDidWeCollideWithScene ; Just in case we hit some words ;)
    lda #False
    sta CollidedWithBackground

    rts

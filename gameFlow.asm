
gfStatusJumpTableLo
    BYTE <gfStatusMenu
    BYTE <gfStatusInFlight
    BYTE <gfStatusLanded
    BYTE <gfStatusDying
    BYTE <gfStatusDead

gfStatusJumpTableHi
    BYTE >gfStatusMenu
    BYTE >gfStatusInFlight
    BYTE >gfStatusLanded
    BYTE >gfStatusDying
    BYTE >gfStatusDead

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
    lda #GF_Landed
    sta GameStatus
    
@SoFarNotLanded
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
    jmp gfStatusDead

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
    jsr libInputUpdate

    LIBINPUT_GETHELD GameportFireMask
    bne @NoGameReset

    pla
    pla
    LIBSPRITE_DIDCOLLIDEWITHDATA_A LunaLanderSpNo
    ;lda SPBGCL
    lda #False
    sta CollidedWithBackground
    jmp GameStart

@NoGameReset
    rts

gfHaveWeSafelyLanded

    ;LIBLUNA_CHECKLANDINGSITE_VVV $0108, $0111, $CA
    LIBLUNA_CHECKLANDINGSITE_AAA LandingPadThreeXStart, LandingPadThreeXFinish, LandingPadThreeYStart
    bcc @TestSecondLandSite
    jmp gfWeHaveLanded
    
@TestSecondLandSite
    ;LIBLUNA_CHECKLANDINGSITE_VVV $008C, $0091, $84
    LIBLUNA_CHECKLANDINGSITE_AAA LandingPadTwoXStart, LandingPadTwoXFinish, LandingPadTwoYStart
    bcc @TestThirdLandSite
    jmp gfWeHaveLanded

@TestThirdLandSite
    ;LIBLUNA_CHECKLANDINGSITE_VVV $003F, $0042, $E4
    LIBLUNA_CHECKLANDINGSITE_AAA LandingPadOneXStart, LandingPadOneXFinish, LandingPadOneYStart
    bcc gfWeHaveLanded          ; Not Landed Legally
    jmp gfWeHaveLanded

gfWeHaveLanded
    rts

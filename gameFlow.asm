
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

gfStatusMenu
    rts

gfStatusInFlight
    lda CollidedWithBackground
    cmp #False
    beq @NotCollided

;    lda LunaLanderXHi
;    cmp #1
;    bne @ConfirmCollided

;    lda LunaLanderXLo
;    cmp #40
;    bcs @ConfirmYBarStatus
;    jmp @ConfirmCollided

;@ConfirmYBarStatus
;    lda LunaLanderY
;    cmp #155
;    bcc gfStatusInFlightOK
;    jmp @ConfirmCollided

@ConfirmCollided
    lda #GF_Dying
    sta GameStatus

@NotCollided
    rts

;gfStatusInFlightOK
;    lda #False
;    sta CollidedWithBackground
;    rts

gfStatusLanded
    rts

gfStatusDying
    LIBSPRITE_ISANIMPLAYING_A LunaLanderSpNo
    bne @NotFinishedDying

    lda #GF_Dead
    sta GameStatus

@NotFinishedDying
    rts

gfStatusDead
    jsr libInputUpdate

    LIBINPUT_GETHELD GameportFireMask
    bne @NoGameReset

    pla
    pla
    LIBSPRITE_DIDCOLLIDEWITHDATA_A LunaLanderSpNo
    jmp GameStart

@NoGameReset
    rts



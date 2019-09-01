
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

    lda #GF_Dying
    sta GameStatus

@NotCollided
    rts

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



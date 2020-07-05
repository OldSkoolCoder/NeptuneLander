;********************************************************
;* Prepare to Land Captain Text
gsPrepareToLanderCaptain
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

;********************************************************
;* Display "The Eagle Has Landed"
gsTheEagleHasLanded
    ldy #>txtHoustonTheEagleHasLanded
    lda #<txtHoustonTheEagleHasLanded
    jmp $AB1E

;********************************************************
; This scrolls the middle section down one row on the
; screen.
gsUpdateIntroScreen

    ldy #23
@gsCharacterLoopSection
    ; Last Section First


;    lda $07C0+ 8,y
;    sta $07E8+ 8,y

;    lda $DBC0+ 8,y
;    sta $DBE8+ 8,y

    ;lda $0798+ 8,y
    ;sta $07C0+ 8,y

    ;lda $DB98+ 8,y
    ;sta $DBC0+ 8,y

    ;lda $0770+ 8,y
    ;sta $0798+ 8,y

    ;lda $DB70+ 8,y
    ;sta $DB98+ 8,y

    ;lda $0748+ 8,y
    ;sta $0770+ 8,y

    ;lda $DB48+ 8,y
    ;sta $DB70+ 8,y

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
    beq @gsDone
    jmp @gsCharacterLoopSection

@gsDone

; ****************************************************************************
; Get Next Row of the Lander Craft and Place on top row of screen
gsPlaceNextRowOfAircraft

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
@gsloop
    lda (ZeroPageLow),y
    sta COLORRAM,y
    lda (ZeroPageLow2),y
    sta SCREENRAM,y

    iny
    cpy #40
    bne @gsloop

    rts

; ***********************************************************************
;  Scroll the entire screen down to the bottom
gsScrollScreenDown

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

    LIBSCREEN_SCROLLYRESET_A gsPlaceNextRowOfAircraft
    LIBSCREEN_SET24ROWMODE

    lda #24
    sta screenRow

    lda #43
    sta gsScrollLooper + 1

    lda #0
    sta GameLoopFrameTracker

gsScrollLooper

    lda #128            ; Scanline -> A
    cmp RASTER          ; Compare A to current raster line
    bne gsScrollLooper    ; Loop if raster line not reached 255

    lda GameLoopFrameTracker
    clc
    adc #$80
    sta GameLoopFrameTracker
    bcc gsScrollLooper

    LIBSCREEN_SCROLLYDOWN_A gsUpdateIntroScreen

    lda screenRow
    cmp #$FF
    beq @gsEnd
    inc gsScrollLooper + 1
    jmp gsScrollLooper

@gsEnd

    ldy #0
@gsScreenColourLooper
    lda $DA8F,y
    and #$0F
    cmp #Orange
    bne @gsContinue
    lda #Black
    sta $DA8F,y
@gsContinue
    iny
    bne @gsScreenColourLooper

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

@gsScanAgain
    jsr libInputUpdate

    LIBINPUT_GETHELD GameportFireMask
    bne @gsScanAgain
    rts

;********************************************************
;* Display "Please select difficulty"
gsPleaseSelectDifficulty

    ldy #>txtWhichDifficultyLevel
    lda #<txtWhichDifficultyLevel
    jmp $AB1E

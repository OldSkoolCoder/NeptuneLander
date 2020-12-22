;********************************************************
;* Prepare to Land Captain Text
gsPrepareToLanderCaptain
    lda #$93
    jsr krljmp_CHROUT$

    ldy #>txtPrepareToLandCaptain
    lda #<txtPrepareToLandCaptain
    jsr libPrint_PrintString
    
    rts

;********************************************************
;* Display "The Eagle Has Landed"
gsTheEagleHasLanded
    ldy #>txtHoustonTheEagleHasLanded
    lda #<txtHoustonTheEagleHasLanded
    jmp libPrint_PrintString

;********************************************************
; This scrolls the middle section down one row on the
; screen.
gsUpdateIntroScreen

    ldy #8
@gsCharacterLoopSection
    ; Last Section First

    ;LIBSCREEN_COPYROW $07C0
    ;LIBSCREEN_COPYROW $0798
    ;LIBSCREEN_COPYROW $0770
    ;LIBSCREEN_COPYROW $0748
    ;LIBSCREEN_COPYROW $0720
    LIBSCREEN_COPYROW $06F8
    LIBSCREEN_COPYROW $06D0
    LIBSCREEN_COPYROW $06A8
    LIBSCREEN_COPYROW $0680
    LIBSCREEN_COPYROW $0658
    LIBSCREEN_COPYROW $0630
    LIBSCREEN_COPYROW $0608
    LIBSCREEN_COPYROW $05E0
    LIBSCREEN_COPYROW $05B8
    LIBSCREEN_COPYROW $0590
    LIBSCREEN_COPYROW $0568
    LIBSCREEN_COPYROW $0540
    LIBSCREEN_COPYROW $0518
    LIBSCREEN_COPYROW $04F0
    LIBSCREEN_COPYROW $04C8
    LIBSCREEN_COPYROW $04A0
    LIBSCREEN_COPYROW $0478
    LIBSCREEN_COPYROW $0450
    LIBSCREEN_COPYROW $0428
    LIBSCREEN_COPYROW $0400

    iny
    cpy #32
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
    jsr libPrint_PrintString

    ldy #>txtNeptuneLanderTitle2
    lda #<txtNeptuneLanderTitle2
    jsr libPrint_PrintString

    lda InputDevice
    cmp #idJoystick
    bne @gsKeyboardinstead
    ldy #>txtNeptuneLanderTitle4
    lda #<txtNeptuneLanderTitle4
    jsr libPrint_PrintString

@gsScanJoyStickAgain
    jsr libInputUpdate

    LIBINPUT_GETHELD GameportFireMask
    bne @gsScanJoyStickAgain
    rts

@gsKeyboardinstead
    ldy #>txtNeptuneLanderTitle3
    lda #<txtNeptuneLanderTitle3
    jsr libPrint_PrintString

gsScanKeyboardAgain
    lda 197
    cmp #scanCode_SPACEBAR$
    bne @gsTestLeftArrow
    jmp gsSpacePressed
@gsTestLeftArrow
    cmp #scanCode_LEFT_ARROW$
    bne gsScanKeyboardAgain
    lda DemoMode
    eor #$FF
    sta DemoMode

    ldy #0
@gsScreenColourDemoLooper
    lda $D880,y
    and #$0F
    cmp DemoColour
    bne @gsTestSecodArea
    eor #$0D
    sta $D880,y

@gsTestSecodArea
    lda $D980,y
    and #$0F
    cmp DemoColour
    bne @gsLoopBackRound
    eor #$0D
    sta $D980,y

@gsLoopBackRound
    iny
    bne @gsScreenColourDemoLooper

    lda DemoColour
    eor #$0D
    sta DemoColour
    LIBINPUT_DELAY_V 255
    LIBINPUT_DELAY_V 255
    LIBINPUT_DELAY_V 255
    jmp gsScanKeyboardAgain

gsSpacePressed
    rts

;********************************************************
;* Display "Please select difficulty"
gsPleaseSelectDifficulty

    ldy #>txtWhichDifficultyLevel
    lda #<txtWhichDifficultyLevel
    jmp libPrint_PrintString

;********************************************************
;* Display "The Current Level"
gsDisplayCurrentLevel
    ldy #>txtLevelNotification
    lda #<txtLevelNotification
    jsr libPrint_PrintString
    lda GameLevel
    clc
    adc #$31
    sta 1248
    
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
;* Display "Please select (k)eyboard or (j)oystick"
gsPleaseSelectInputDevice

    ldy #>txtWhichInputDevice
    lda #<txtWhichInputDevice
    jmp libPrint_PrintString

;********************************************************
;* Display keybaord instructions
gsShowKeyboardInstructions

    ldy #>txtKeyboardDevice
    lda #<txtKeyboardDevice
    jmp libPrint_PrintString

;********************************************************
;* Display joystick instructions
gsShowJoystickInstructions

    ldy #>txtJoystickDevice
    lda #<txtJoystickDevice
    jmp libPrint_PrintString




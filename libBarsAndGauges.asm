XSCRNLOC = ZeroPageParam1
YSCRNLOC = ZeroPageParam3
YGAUGLOC = ZeroPageParam5

XVALUE              ; X Velocity Value
    BYTE 00

YVALUE              ; Y Velocity Value
    BYTE 00

YPOS                ; Y Position (Height)
    BYTE 00

XPOS                ; X Position
    BYTE 00

XINDEXPOS
    BYTE 00

YINDEXPOS
    BYTE 00

YGAUGEINDEX
    BYTE 00

XBARCHARACTERS
    BYTE $20,$65,$54,$47,$5D,$48,$59,$67,$67 
    ;     0   1   2   3   4   5   6   7   8

YBARCHARACTERS
    BYTE $20,$77,$45,$44,$40,$46,$52,$6F,$6F
    ;     0   1   2   3   4   5   6   7   8

YGAUGECHARACTERS
    BYTE $20,$63,$77,$78,$E2,$F9,$EF,$E4,$E4
    ;     0   1   2   3   4   5   6   7   8

YSCREENOFFSETLO
    BYTE $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68,$90,$B8,$E0
    BYTE $08,$30,$58,$80,$A8,$D0,$F8,$20,$48,$70,$98,$C0,$E8
YSCREENOFFSETHI
    BYTE $00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01
    BYTE $02,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03,$03

defm LIBBARSANDGAUGES_INITYBAR_AV   ; /1 = Start Location (Address)
                                    ; /2 = Iterations (Value)
    ldx #</1
    lda #>/1
    sta @SCREENLOC+2
    stx @SCREENLOC+1
    ldx #0
@LOOP
    lda #160
@SCREENLOC
    sta /1
    clc
    lda #40
    adc @SCREENLOC+1
    sta @SCREENLOC+1
    lda #0
    adc @SCREENLOC+2
    sta @SCREENLOC+2
    inx
    cpx #/2
    bne @LOOP
endm

defm LIBBARSANDGAUGES_INITXBAR_AV  ; /1 Start Location (Address)
                                   ; /2 Iterations (Value)
    ldx #0
@LOOP
    lda #160
    sta /1,x
    inx
    cpx #/2
    bne @LOOP
endm

defm LIBBARSANDGAUGES_SHOWXCENTREBAR
    ; Input Paramters : Acc = Value

    pha                 ; Store Away Value Safely
    bmi @NEGATIVEVALUE
    lsr                 ; Divide By 2
    lsr                 ; Divide By 4
    lsr                 ; Divide By 8
    cmp XINDEXPOS
    beq @XPOSSAME
    pha
    lda XBARCHARACTERS
    ora #$80
    ldy #0
    sta (XSCRNLOC),y
    pla
@XPOSSAME
    sta XINDEXPOS
    sta $0401
    clc
    adc #</1
    sta XSCRNLOC
    lda #0
    adc #>/1
    sta XSCRNLOC + 1
    pla
    and #$07
    tay
    iny
    jmp @END
@NEGATIVEVALUE
    eor #$FF
    clc
    adc #1
    lsr
    lsr
    lsr
    clc
    adc #01
    cmp XINDEXPOS
    beq @XPOSSAME1
    pha
    lda XBARCHARACTERS
    ora #$80
    ldy #0
    sta (XSCRNLOC),y
    pla
@XPOSSAME1
    sta XINDEXPOS
    sta $0401
    lda #</1
    sec
    sbc XINDEXPOS
    sta XSCRNLOC
    lda #>/1
    sbc #0
    sta XSCRNLOC + 1
    pla
    and #$07
    tay
    iny
@END
    sty $0400
    lda XBARCHARACTERS,y
    ora #128
    ldy #0
    sta (SCRNLOC),y
endm

defm LIBBARSANDGAUGES_SHOWXBAR_AV   ; /1 = Start Screen Location (Address)
                                    ; /2 = Offset (Value)

    ; Input Paramters : Acc = Value
    clc
    adc #/2             ; Adds Centre Ofset
    pha                 ; Store Away Value Safely
    lsr                 ; Divide By 2
    lsr                 ; Divide By 4
    lsr                 ; Divide By 8
    cmp XINDEXPOS
    beq @XPOSSAME
    pha                 ; Store Away New XINDEXPOS Temporarily
    lda XBARCHARACTERS
    ora #$80
    ldy #0
    sta (XSCRNLOC),y     ; Blank out last location
    pla                 ; Get back New XINDEXPOS
@XPOSSAME
    sta XINDEXPOS
    sta $0401
    clc
    adc #</1
    sta XSCRNLOC
    lda #0
    adc #>/1
    sta XSCRNLOC + 1
    pla
    and #$07
    tay
    iny
    sty $0400
    lda XBARCHARACTERS,y
    ora #128
    ldy #0
    sta (XSCRNLOC),y
endm

defm LIBBARSANDGAUGES_SHOWYBAR_AV   ; /1 = Start Screen Location (Address)
                                    ; /2 = Offset (Value)

    ; Input Parameters : Acc = Value
    clc
    adc #/2             ; Adds Centre Offset
    pha                 ; Store Away Value Safely
    lsr                 ; Divide By 2
    lsr                 ; Divide By 4
    lsr                 ; Divide By 8
    cmp YINDEXPOS
    beq @YPOSSAME
    pha                 ; Store Away New YINDEXPOS Temporarily
    lda YBARCHARACTERS
    ora #$80
    ldy #0
    sta (YSCRNLOC),y     ; Blank out last location
    pla                 ; Get back New YINDEXPOS
@YPOSSAME
    sta YINDEXPOS
    tax
    ;sta $0401
    clc
    lda #0
    adc YSCREENOFFSETLO,x
    sta YSCRNLOC
    lda #0
    adc YSCREENOFFSETHI,x
    sta YSCRNLOC + 1
    clc
    lda YSCRNLOC
    adc #</1
    sta YSCRNLOC
    lda YSCRNLOC + 1
    adc #>/1
    sta YSCRNLOC + 1
    pla
    and #$07
    tay
    iny
    ;sty $0400
    lda YBARCHARACTERS,y
    ora #128
    ldy #0
    sta (YSCRNLOC),y
endm

defm LIBBARSANDGAUGES_SHOWYGAUGE_AV ; /1 = Start Screen Location (Address)
                                    ; /2 = Offset (Value)

    ; Input Parameter : Acc = Value
    clc
    adc #/2             ; Adds Centre Offset
    pha                 ; Store Away Value Safely
    lsr                 ; Divide By 2
    lsr                 ; Divide By 4
    lsr                 ; Divide By 8
    cmp YGAUGEINDEX     ; Is new location same as old location?
    beq @YSAME           ; Yes, then skip the next instructions
    pha                 ; Store Away New XINDEXPOS Temporarily
    tay
    lda YGAUGECHARACTERS; Get first character from GAUGE Character Set
    cpy YGAUGEINDEX
    bcs @YGaugeClearFill
    ora #$80
@YGaugeClearFill
    ldy #0
    sta (YGAUGLOC),y    ; Blank out last location
    pla                 ; Get back New XINDEXPOS
@YSAME
    sta YGAUGEINDEX     ; Store New Location
    tax                 ; transfer to index register
    clc
    lda #0
    adc YSCREENOFFSETLO,x   ; Add screen row offset (lo)
    sta YGAUGLOC            ; store in pointer (lo)
    lda #0
    adc YSCREENOFFSETHI,x   ; Add screen row offset (hi)
    sta YGAUGLOC + 1        ; store in pointer (hi)
    clc
    lda YGAUGLOC        ; Get screen pointer (lo)
    adc #</1            ; Add screen location (lo)
    sta YGAUGLOC        ; Store back to pointer (lo)
    lda YGAUGLOC + 1    ; Get screen pointer (hi)    
    adc #>/1            ; Add screen location (hi)
    sta YGAUGLOC + 1    ; Store back pointer (hi)
    pla                 ; Get back Value from stack
    and #$07            ; mask off the 3 least significant bits (value/8)
    tay                 ; Move to index register
    iny                 ; add 1
    lda YGAUGECHARACTERS,y  ; Get corresponding YGaugeCharacter From Set
    eor #$80            ; invert the character
    ldy #0              ; init Y
    sta (YGAUGLOC),y    ; store character on screen
endm


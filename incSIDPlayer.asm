SetUpSIDPlayer
    sei
    lda #<irq
    ldx #>irq
    sta $314
    stx $315
    lda #$1b
    ldx #$00
    ldy #$7f 
    sta $d011
    stx $d012
    sty $dc0d
    lda #$01
    sta $d01a
    sta $d019 ; ACK any raster IRQs
    lda #$00
    jsr $1000
    cli

hold
    ;jmp hold
    rts
    ;
    ;jmp hold ;We don't want to do anything else here. :)

; we could also RTS here, when also changing $ea81 to $ea31
irq
    lda #$01
    sta $d019 ; ACK any raster IRQs
    jsr $1003
    jmp $ea81

* = $1000 ; Dark Tower & Acid Mix
incbin "Acid_Mix.sid", $7E
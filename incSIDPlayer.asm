SetUpSIDPlayer

    sei
    lda #<irq
    ldx #>irq
    sta $314
    stx $315

    lda TitleMusicSet
    cmp #True
    beq Hold
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
    jsr $1048
    lda #True
    sta TitleMusicSet

hold
    cli

    ;jmp hold
    rts
    ;
    ;jmp hold ;We don't want to do anything else here. :)

; we could also RTS here, when also changing $ea81 to $ea31
irq
    ;pha
    ;txa
    ;pha
    ;tya
    ;pha
    asl $d019 ; ACK any raster IRQs
    jsr $1021
    jmp $ea31

* = $1000 ; Dark Tower & Acid Mix
;incbin "Acid_Mix.sid", $7E

; $1000 - $1800
incbin "Lander.sid", $7E

; $7000 - $ADF1
;* = $7000
;incbin "Mission_Jupiter.sid", $7E

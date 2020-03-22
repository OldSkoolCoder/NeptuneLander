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
    ;jsr $C810 ;Deflektor
    jsr $1D00 ; Dark Tower Init
    ;jsr $3003 ; MDG Init
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
    jsr $1B85 ;Dark Town Play
    ;jsr $C106 ;Deflektor
    ;jsr $3000   ; Play MDG
    jmp $ea31

;*=$C000
;*=$3000 ;MDG
* = $1000 ; Dark Tower
;incbin "deflektor.sid.prg", $7E
;incbin "mdg radwar.prg", $7E
incbin "dark_tower.sid.prg", $7E
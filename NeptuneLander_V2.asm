; 10 SYS (2080)

*=$0801

        BYTE $0E, $08, $0A, $00, $9E, $20, $28  
        BYTE $32, $30, $38, $30, $29, $00, $00, $00

; Sprite Data
*=$2A80
; Load Sprites 1-> 5 padded to 64 bytes
incbin "NeptuneLander.spt", 1, 6 ,true
incbin "DereksExplosions.spt", 5, 16, true

; CharacterSet
*=$3000
incbin "LandScape.cst", 0, 255

*=$0820
        jmp GameStart

incasm "libSprite.asm"
incasm "libMath.asm"
incasm "libInput.asm"
incasm "libConstants.asm"
incasm "libScreen.asm"
incasm "libPrint.asm"
incasm "libBarsAndGauges.asm"
incasm "libLuna.asm"
incasm "gameMemory.asm"
incasm "gameLander.asm"
incasm "gameBars.asm"
incasm "gameFlow.asm"

GameStart
        ;jsr SetUpLevelOneScene
        ldx #0 ; Level 1
        ldy #1 ; Normal / Easy Difficulty
        jsr gmSetUpGameVariables
        jsr glSetUpLunarSprite
        jsr gmSetUpCustomCharacters
        jsr gbSetUpFuelAndSpeedBars

GameLoop
        LIBSCREEN_WAIT_V 255

        ;lda #1
        ;sta EXTCOL

        ;LIBSCREEN_DEBUG16BIT_VVAA 1,1,VerticalVelocity, VerticalVelocityFrac
        ;LIBSCREEN_DEBUG8BIT_VVA 8,1,LunaLanderY

        ;lda GameLoopFrameTracker
        ;bne GameLooper

        lda DemoMode
        cmp #255
        bne @NotInDemoMode
        jsr glDebugReadInputAndUpdateVariables
        jsr glUpdateSpritePosition
        jsr glDidWeCollideWithScene
        jmp GameDebugByPass

@NotInDemoMode
        lda CollidedWithBackground
        cmp #True
        beq GameLooper

        jsr glReadInputAndUpdateVariables
        jsr glUpdateSpritePosition
        jsr glDidWeCollideWithScene

        jsr gbUpdateBarsAndGauges

GameLooper
        jsr gfUpdateGameFlow

GameDebugByPass
        jsr libSpritesUpdate

        ;lda GameLoopFrameTracker
        ;clc
        ;adc #$01
        ;and FrameSkipRate
        ;sta GameLoopFrameTracker

        ;lda #0
        ;sta EXTCOL

        jmp GameLoop
        rts

ScnLevelOne
        TEXT "{white}{clear}{down*8}gg{down}bc{down}d{down}h{down}{left}j{down}h{down}{left}j{down}{left}i{down}{left}k{down}{left*2}e{down}{left*3}@a{down}{left*3}e{down}{left*2}e{down}{left}d{down}d{down}d{down}dlllk{up}{left}i"
        TEXT "{up}{left}j{up}{left}h{up}{left}e{up}e{up}@a{up}e{up}k{up}{left}i{up}k{up}{left}i{up}lllk{up}{left}i{up}{left}d{up}{left*2}d{up}{left}@a{up}e{up}k{up}{left}i{up}f{down}dgg{down}h{down}{left}j{down}h{down}{left}j"
        TEXT "{down}{left}i{down}{left}k{down}{left}h{down}{left}j{down}h{down}{left}j{down}{left}e{down}{left*2}e{down}{left}h{down}{left}j{down}d{down}bcllllebc{down}bc{down}d"
        BYTE 0

SetUpLevelOneScene
        LIBPRINT_PRINTSTRING_A ScnLevelOne
        rts
        


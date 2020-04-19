; 10 SYS (2080)

*=$0801

        BYTE $0E, $08, $0A, $00, $9E, $20, $28  
        BYTE $32, $30, $38, $30, $29, $00, $00, $00

*=$0820
        jmp GameStart

incasm "incSIDPlayer.asm"

; Sprite Data
*=$2A80
; Load Sprites 1-> 5 padded to 64 bytes
incbin "NeptuneLander.spt", 1, 6 ,true
incbin "DereksExplosions.spt", 5, 16, true
incbin "NeptuneLanderExtended.spt", 1, 1, true

; CharacterSet
*=$3000
incbin "SevenUp.cst", 0, 255

*=$3800
SplashScreen
incbin "Intro2.sdd", 1, 1

*=$4000
incasm "libSprite.asm"
incasm "libMath.asm"
incasm "libInput.asm"
incasm "libConstants.asm"
incasm "libScreen.asm"
incasm "libPrint.asm"
incasm "libBarsAndGauges.asm"
incasm "libLuna.asm"
incasm "libScoringSystem.asm"
incasm "gameMemory.asm"
incasm "gameLander.asm"
incasm "gameBars.asm"
incasm "gameFlow.asm"

GameStart
        jsr gmSetUpCustomCharacters

        ldx #0 ; Level 1
        ldy #0 ; Normal=1 / Easy=0 / Hard=2 Difficulty
        stx GameLevel
        sty GameDifficulty

        lda #GF_Title
        sta GameStatus

GameLoop
        LIBSCREEN_WAIT_V 255

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

        jsr gbUpdateBarsAndGauges

GameLooper
        jsr gfUpdateGameFlow

GameDebugByPass
        jsr libSpritesUpdate

        jmp GameLoop
        

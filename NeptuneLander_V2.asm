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
incbin "NeptuneLanderExtended.spt", 1, 11, true

; CharacterSet
*=$3800
incbin "SevenUpV2.cst", 0, 255

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
incasm "libSound.asm"
incasm "gameMemory.asm"
incasm "gameLander.asm"
incasm "gameBars.asm"
incasm "gameFlow.asm"
incasm "gameScreens.asm"

GameStart
    lda #GF_Initialise             ; Initialise the Game
    sta GameStatus

    ;lda #255
    ;sta DemoMode

GameLoop
    LIBSCREEN_WAIT_V 240

    ;LIBSCREEN_DEBUG16BIT_VVAA 1,1,VerticalVelocity, VerticalVelocityFrac
    ;LIBSCREEN_DEBUG8BIT_VVA 8,1,LunaLanderY

    jsr gfUpdateGameFlow

GameDebugByPass
    jsr libSpritesUpdate
    jsr libSoundUpdate
    jmp GameLoop
        
*=$6000
SplashScreen
incbin "Intro2.sdd", 1, 1

; ============================================================================
; Level Landscapes

gmLevelOneLandscape
incbin "NewLandScapeV2.sdd", 1, 1,CHAR

gmLevelTwoLandscape
incbin "NewLandScapeV2.sdd", 2, 2,CHAR

gmLevelThreeLandscape
incbin "NewLandScapeV2.sdd", 3, 3,CHAR



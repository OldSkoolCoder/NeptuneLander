;===============================================================================
; Constants

 ; use joystick 2, change to CIAPRB for joystick 1
JoystickRegister        = CIAPRA

GameportUpMask          = %00000001
GameportDownMask        = %00000010
GameportLeftMask        = %00000100
GameportRightMask       = %00001000
GameportFireMask        = %00010000
GameportNoInputMask     = %00011111
FireDelayMax            = 30

;===============================================================================
; Variables

gameportLastFrame       byte 0
gameportThisFrame       byte 0
gameportDiff            byte 0
fireDelay               byte 0
fireBlip                byte 1 ; reversed logic to match other input


keyboardScanByte
    byte 0,0,0,0,0,0,0,0,0


;===============================================================================
; Macros/Subroutines

defm    LIBINPUT_GETHELD ; (buttonMask)

        lda gameportThisFrame
        and #/1
        endm ; test with bne on return

;===============================================================================

defm    LIBINPUT_GETFIREPRESSED
     
        lda #1
        sta fireBlip ; clear Fire flag

        ; is fire held?
        lda gameportThisFrame
        and #GameportFireMask
        bne @notheld

@held
        ; is this 1st frame?
        lda gameportDiff
        and #GameportFireMask
        
        beq @notfirst
        lda #0
        sta fireBlip ; Fire

        ; reset delay
        lda #FireDelayMax
        sta fireDelay        
@notfirst

        ; is the delay zero?
        lda fireDelay
        bne @notheld
        lda #0
        sta fireBlip ; Fire
        ; reset delay
        lda #FireDelayMax
        sta fireDelay   
        
@notheld 
        lda fireBlip
        endm ; test with bne on return

;===============================================================================

libInputUpdate

        lda JoystickRegister
        sta GameportThisFrame

        eor GameportLastFrame
        sta GameportDiff

        
        lda FireDelay
        beq lIUDelayZero
        dec FireDelay
lIUDelayZero

        lda GameportThisFrame
        sta GameportLastFrame

        rts

; ==============================================================================
defm    LIBINPUT_DELAY_V ; no. of y loops
        ldy #/1
@loopy
        ldx #$FF
@loopx
        dex
        bne @loopx
        dey
        bne @loopy
        endm

;=============================================================================
defm    LIBINPUT_SCANKEYBRD_BIT     ; Acc = Bit To scan, Y = Result

;                                   Parameters /1 = ResultLocation

    rol
    sta $DC00
    ldy $DC01
    sty /1
    endm


libInput_ScanKeyboardMatrix

    ldy #0
    lda #$FF
@ClearMatrix
    sta keyboardScanByte,y
    iny
    cpy #9
    bne @ClearMatrix
    
    ldx #$FF
    stx $DC02       ; Set Port A for Output
    ldy #$00
    sty $DC03       ; Set Port B for Input

    sty $DC00       ; Key For Activity
    cpx $DC01
    beq @NoKeyboardActivity

;    stx $DC00
;    cpx $DC01
;    bne @NoKeyboardActivity
    
    clc
    lda #%11111111
    LIBINPUT_SCANKEYBRD_BIT keyboardScanByte
    LIBINPUT_SCANKEYBRD_BIT keyboardScanByte + 1 
    LIBINPUT_SCANKEYBRD_BIT keyboardScanByte + 2 
    LIBINPUT_SCANKEYBRD_BIT keyboardScanByte + 3 
    LIBINPUT_SCANKEYBRD_BIT keyboardScanByte + 4 
    LIBINPUT_SCANKEYBRD_BIT keyboardScanByte + 5 
    LIBINPUT_SCANKEYBRD_BIT keyboardScanByte + 6 
    LIBINPUT_SCANKEYBRD_BIT keyboardScanByte + 7

    lda #$FF
    and keyboardScanByte
    and keyboardScanByte + 1
    and keyboardScanByte + 2
    and keyboardScanByte + 3
    and keyboardScanByte + 4
    and keyboardScanByte + 5
    and keyboardScanByte + 6
    and keyboardScanByte + 7
    sta keyboardScanByte + 8
;    stx $DC00
;    cpx $DC01
;    bne @NoKeyboardActivity

@NoKeyboardActivity
    rts

;===============================================================================
; Constants

;===============================================================================
; Variables

;===============================================================================
; Macros

defm    LIBPRINT_PRINTSTRING_A  ; /1 = Text terminated by 0 (Address)
       
        ldy #0

@GetNextCharacter
        lda /1,y
        beq @End
        jsr krljmp_CHROUT$
        iny
        beq @End
        jmp @GetNextCharacter

@End
        endm  

;===============================================================================

; Input Parameters : acc = Lo byte, y = Hi Byte

libPrint_PrintString
    sty @PrintLooper + 2
    sta @PrintLooper + 1

    ldy #0
@PrintLooper
    lda $1111,y
    cmp #0
    beq @EndPrint
    jsr krljmp_CHROUT$
    iny
    bne @PrintLooper
    inc @PrintLooper + 2
    jmp @PrintLooper

@EndPrint
    rts
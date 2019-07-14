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
        endm


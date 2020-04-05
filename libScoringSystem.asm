;===============================================================================
; Macros/Subroutines

defm    LIBSCORING_ADDSCORE_AA         ; /1 = Address of Score to Add (0-255)
                                       ; /2 = Address of the score

    sed         ; set decimal mode
    clc
    lda /1      ; x points scored
    adc /2      ; ones and tens
    sta /2

    lda /2+1    ; hundreds and thousands
    adc #00
    sta /2+1
    lda /2+2    ; ten-thousands and hundred-thousands
    adc #00
    sta /2+2
    cld

endm

defm    LIBSCORING_DISPLAYSCORESET_AA   ; /1 = Score Address Location
                                        ; /2 = Screen Position Address

    lda /1
    and #$f0        ; hundred-thousands
    lsr
    lsr
    lsr
    lsr
    ora #$30        ; -->ascii
    sta /2          ; print on screen
    lda /1
    and #$0f        ; ten-thousands
    ora #$30        ; -->ascii
    sta /2+1        ; print on next screen position


endm

defm    LIBSCORING_DISPLAYSCORE_AA      ; /1 = Score Address Location
                                        ; /2 = Screen Position Address

    LIBSCORING_DISPLAYSCORESET_AA /1+2, /2
    LIBSCORING_DISPLAYSCORESET_AA /1+1, /2+2
    LIBSCORING_DISPLAYSCORESET_AA /1, /2+4
 
endm
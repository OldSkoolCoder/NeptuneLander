;===============================================================================
; Macros/Subroutines

defm    LIBLUNA_CHECKLANDINGSITE_VVV   ; /1 = XLower (16 Bit Value)
                                       ; /2 = XUpper (16 Bit Value)
                                       ; /3 = YUpper (8 Bit Value)

                                       ; Result = Carry Set = Success,
                                       ;          Carry Clear = Dead
    lda LunaLanderXHi
    cmp #>/1
    beq @LanderFirstLoTest
    bcs @LanderHasNotLanded

@LanderFirstLoTest
    lda LunaLanderXLo
    cmp #</1
    bcs @LandingSecondTest
    jmp @LanderHasNotLanded

@LandingSecondTest
    lda LunaLanderXHi
    cmp #>/2
    beq @LanderSecondLoTest
    bcs @LanderHasNotLanded

@LanderSecondLoTest
    lda LunaLanderXLo
    cmp #</2
    bcc @LandingFirstTest
    jmp @LanderHasNotLanded

@LandingFirstTest
    lda LunaLanderY
    cmp #/3
    bcs @WeHaveLanded

@LanderHasNotLanded
    clc
    jmp @Done

@WeHaveLanded
    sec

@Done

endm

;==============================================================================

;===============================================================================
; Macros/Subroutines

defm    LIBLUNA_CHECKLANDINGSITE_AAA   ; /1 = XLower (16 Bit Address)
                                       ; /2 = XUpper (16 Bit Address)
                                       ; /3 = Y (16 Bit Address)

                                       ; Result = Carry Set = Success,
                                       ;          Carry Clear = Dead
    lda LunaLanderXHi
    cmp /1 + 1
    beq @LanderFirstLoTest
    bcs @LanderHasNotLanded

@LanderFirstLoTest
    lda LunaLanderXLo
    cmp /1
    bcs @LandingSecondTest
    jmp @LanderHasNotLanded

@LandingSecondTest
    lda LunaLanderXHi
    cmp /2 + 1
    beq @LanderSecondLoTest
    bcs @LanderHasNotLanded

@LanderSecondLoTest
    lda LunaLanderXLo
    cmp /2
    bcc @LandingFirstTest
    jmp @LanderHasNotLanded

@LandingFirstTest
    lda LunaLanderY
    cmp /3
    bcs @WeHaveLanded

@LanderHasNotLanded
    clc
    jmp @Done

@WeHaveLanded
    sec

@Done

endm

;==============================================================================

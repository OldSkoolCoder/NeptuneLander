gbUpdateBarsAndGauges
        lda VerticalVelocityFracHi      ; Load Hi Value
        sta VerticalBarValue            ; Bar Value
        lda VerticalVelocity            ; Load Vertical Velocity
        lsr                             ; /2
        ror VerticalBarValue
        lsr                             ; /4
        ror VerticalBarValue
        lsr                             ; /8
        ror VerticalBarValue
        lda VerticalBarValue            ; load Bar Value
        eor #$FF                        ; NOT The result (Invert)

        LIBBARSANDGAUGES_SHOWYBAR_AV $044E, $2C

        lda FuelBarValue
        LIBBARSANDGAUGES_SHOWYGAUGE_AV $044D, $00

        rts

gbSetupFuelAndSpeedBars
        LIBBARSANDGAUGES_INITYBAR_AV $044E,12
        lda #Green
        sta $D916                       ; Indicate Safe Landing Speed Zone

        LIBBARSANDGAUGES_INITYBAR_AV $044D,12
        lda #Red
        sta $D9DD                       ; Show Low Fuel Zone
        sta $DA05
        rts

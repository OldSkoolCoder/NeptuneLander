gbUpdateBarsAndGauges
        lda VerticalVelocityFrac
        sta VerticalBarValue
        lda VerticalVelocity
        lsr 
        ror VerticalBarValue
        lsr 
        ror VerticalBarValue
        lsr 
        ror VerticalBarValue
        lda VerticalBarValue
        eor #$FF
        LIBBARSANDGAUGES_SHOWYBAR_AV $044E, $2C

        lda FuelBarValue
        LIBBARSANDGAUGES_SHOWYGAUGE_AV $044D, $00

        rts

gbSetupFuelAndSpeedBars
        LIBBARSANDGAUGES_INITYBAR_AV $044E,12
        lda #Green
        sta $D916

        LIBBARSANDGAUGES_INITYBAR_AV $044D,12
        lda #Red
        sta $D9DD
        sta $DA05
        rts

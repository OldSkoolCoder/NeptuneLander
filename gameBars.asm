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

        lda MaxSafeLandingSpeed
        lsr                     ; divind by 2
        lsr                     ; divide by 4
        lsr                     ; divide by 8
        tay
        dey

        lda #$D9
        sta SafeZonePlace + 2
        lda #$16
        sta SafeZonePlace + 1

SafeZoneLoop
        lda #Green
SafeZonePlace
        sta $D916                       ; Indicate Safe Landing Speed Zone
        sec
        lda SafeZonePlace + 1
        sbc #40
        sta SafeZonePlace + 1
        bcs @Bypass
        dec SafeZonePlace + 2
@ByPass
        dey
        bpl SafeZoneLoop

        LIBBARSANDGAUGES_INITYBAR_AV $044D,12
        lda #Red
        sta $D9DD                       ; Show Low Fuel Zone
        sta $DA05
        rts

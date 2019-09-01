glSetUpLunarSprite
        lda #60
        sta LunaLanderXLo
        sta LunaLanderY
        lda #0
        sta LunaLanderXHi
        sta LunaLanderSpNo
        sta LunaLanderColour

        lda #Red
        sta ThrustColour
        sta ManuoverColour

        ; POKE 53273, PEEK(53273) OR 2
        lda VICIRQ
        ora #2
        sta VICIRQ

        ; 20 POKE 2040,170 : REM SPRITE POINT * 64 = 170 * 64 = 10880
        ; 25 POKE 2041,186
        LIBSPRITE_SETFRAME_AV LunaLanderSpNo, spLunaLander
        LIBSPRITE_SETFRAME_AV ThrustSpNo, spNoThrust
        LIBSPRITE_SETFRAME_AV ManuoverSpNo, spNoThrust

        ;poke 53269,3
        LIBSPRITE_ENABLE_AV LunaLanderSpNo, True
        LIBSPRITE_ENABLE_AV ThrustSpNo, True
        LIBSPRITE_ENABLE_AV ManuoverSpNo, True

        ; 30 Y = 60 : POKE 53249,Y : POKE 53251,Y
        ; 40 X = 60 : POKE 53248,X : POKE 53250,X
        LIBSPRITE_SETPOSITION_AAAA LunaLanderSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ThrustSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ManuoverSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY

        ; POKE 53287,0
        LIBSPRITE_SETCOLOR_AA LunaLanderSpNo, LunaLanderColour

        ; POKE 53288,2
        LIBSPRITE_SETCOLOR_AA ThrustSpNo, ThrustColour
        LIBSPRITE_SETCOLOR_AA ManuoverSpNo, ManuoverColour
        LIBSPRITE_SETMULTICOLORS_VV Yellow, LightGray

        LIBSPRITE_MULTICOLORENABLE_AV LunaLanderSpNo, False

        rts

glUpdateSpritePosition
        ; 210 Y = (Y+VV) : X = (X+HV)
        LIBMATH_ADD16BIT_AAA LunaLanderYFrac, VerticalVelocityFrac, LunaLanderYFrac
        LIBMATH_ADD16BIT_AAA LunaLanderXFrac, HorizontalVelocityFrac, LunaLanderXFrac

        ;215 POKE 2041,TS : POKE 53250, XL : POKE 53251, Y
        ;216 POKE 53249, Y : POKE 53248,XL : POKE 53264, XH : REM CC=CC+1
        LIBSPRITE_SETFRAME_AA ThrustSpNo, ThrustFrameNo
        LIBSPRITE_SETFRAME_AA ManuoverSpNo, ManuoverFrameNo

        LIBSPRITE_SETPOSITION_AAAA LunaLanderSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ThrustSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ManuoverSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY

        rts

glDidWeCollideWithScene
        LIBSPRITE_DIDCOLLIDEWITHDATA_A LunaLanderSpNo
        beq DidNotCollide
        ;lda #2
        ;sta EXTCOL
        lda #True
        sta CollidedWithBackground

        LIBSPRITE_SETCOLOR_AV     LunaLanderSpNo, Yellow
        LIBSPRITE_MULTICOLORENABLE_AV LunaLanderSpNo, True
        LIBSPRITE_PLAYANIM_AVVVV  LunaLanderSpNo, 5, 16, 3, False

DidNotCollide
        rts

glReadInputAndUpdateVariables
        jsr libInputUpdate

        LIBINPUT_GETHELD GameportLeftMask
        bne @TestRight

        ;130 IF A = 10 THEN HV = HV + HI : TS = 185 :REM A
        LIBMATH_ADD16BIT_AAA HorizontalVelocityFrac, HorizontalInertiaFrac, HorizontalVelocityFrac
        ldx #spThrustLeft
        stx ManuoverFrameNo
        jsr gmAddFuelConsumption

@TestRight
        LIBINPUT_GETHELD GameportRightMask
        bne @TestFire

        ;120 IF A = 18 THEN HV = HV - HI : TS = 184 : REM D
        LIBMATH_SUB16BIT_AAA HorizontalVelocityFrac, HorizontalInertiaFrac, HorizontalVelocityFrac
        ldx #spThrustRight
        stx ManuoverFrameNo
        jsr gmAddFuelConsumption

@TestFire
        LIBINPUT_GETHELD GameportFireMask
        bne @NoInput

        ;110 IF A = 22 THEN VV = VV - T : TS=183 : 
@FireDetected
        LIBMATH_SUB16BIT_AAA VerticalVelocityFrac, ThrustFrac, VerticalVelocityFrac
        ldx #spThrustDown
        stx ThrustFrameNo
        jsr gmAddFuelConsumption
        jsr gmAddFuelConsumption
        jmp @GravityByPass

@NoInput
        LIBINPUT_GETHELD GameportNoInputMask
        cmp #GameportNoInputMask
        bne @InputProcessed
        ldx #spNoThrust
        stx ThrustFrameNo
        stx ManuoverFrameNo

        ;200 VV = VV + G : IF VV > 2 THEN VV = 2
@InputProcessed
        LIBMATH_ADD16BIT_AAA VerticalVelocityFrac, GravityFrac, VerticalVelocityFrac

@GravityByPass
        lda VerticalVelocity
        cmp #2
        bne @InputFinish

        lda #1
        sta VerticalVelocity
        lda #0
        sta VerticalVelocityFrac

@InputFinish
        rts



glSetUpLunarSprite
        lda #70
        sta LunaLanderXLo
        lda #60
        sta LunaLanderY
        lda #0
        sta LunaLanderXHi
        lda #0
        sta LunaLanderSpNo
        lda #DarkGray
        sta LunaLanderColour

        lda #Yellow
        sta LunaLanderWindowCol

        lda #Red
        sta ThrustColour
        sta ManuoverColour

        ; POKE 53273, PEEK(53273) OR 2
        lda VICIRQ
        ora #2
        sta VICIRQ

        ; 20 POKE 2040,170 : REM SPRITE POINT * 64 = 170 * 64 = 10880
        ; 25 POKE 2041,186
        LIBSPRITE_SETFRAME_AA
        LIBSPRITE_SETFRAME_AA LunaLanderSpNo, SpriteShipNo
        LIBSPRITE_SETFRAME_AV ThrustSpNo, spNoThrust
        LIBSPRITE_SETFRAME_AV ManuoverSpNo, spNoThrust
        LIBSPRITE_SETFRAME_AA LunaLanderWindowSpNo, SpriteWindowShipNo

;        LIBSPRITE_SETFRAME_AV LunaLanderSpNo, spLunaLander
;        LIBSPRITE_SETFRAME_AV ThrustSpNo, spNoThrust
;        LIBSPRITE_SETFRAME_AV ManuoverSpNo, spNoThrust
;        LIBSPRITE_SETFRAME_AV LunaLanderWindowSpNo, spLunaLanderWindows

        ;poke 53269,3
        LIBSPRITE_ENABLE_AV LunaLanderSpNo, True
        LIBSPRITE_ENABLE_AV ThrustSpNo, True
        LIBSPRITE_ENABLE_AV ManuoverSpNo, True
        LIBSPRITE_ENABLE_AV LunaLanderWindowSpNo, True

        ; 30 Y = 60 : POKE 53249,Y : POKE 53251,Y
        ; 40 X = 60 : POKE 53248,X : POKE 53250,X
        LIBSPRITE_SETPOSITION_AAAA LunaLanderSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ThrustSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ManuoverSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA LunaLanderWindowSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY

        ; POKE 53287,0
        LIBSPRITE_SETCOLOR_AA LunaLanderSpNo, LunaLanderColour
        LIBSPRITE_SETCOLOR_AA LunaLanderWindowSpNo, LunaLanderWindowCol

        ; POKE 53288,2
        LIBSPRITE_SETCOLOR_AA ThrustSpNo, ThrustColour
        LIBSPRITE_SETCOLOR_AA ManuoverSpNo, ManuoverColour
        LIBSPRITE_SETMULTICOLORS_VV Yellow, LightGray

        LIBSPRITE_MULTICOLORENABLE_AV LunaLanderSpNo, False
        LIBSPRITE_MULTICOLORENABLE_AV LunaLanderWindowSpNo, False

        rts

glUpdateSpritePosition
        ; 210 Y = (Y+VV) : X = (X+HV)
        LIBMATH_ADD16BIT_AAA LunaLanderYFrac, VerticalVelocityFracHi, LunaLanderYFrac
        ;LIBMATH_ADD24BIT_AAA LunaLanderXFrac, HorizontalVelocityFrac, LunaLanderXFrac
        LIBMATH_ADD24BIT2sCOMP_AAA LunaLanderXFrac, HorizontalVelocityFrac, LunaLanderXFrac

        ;215 POKE 2041,TS : POKE 53250, XL : POKE 53251, Y
        ;216 POKE 53249, Y : POKE 53248,XL : POKE 53264, XH : REM CC=CC+1
        LIBSPRITE_SETFRAME_AA ThrustSpNo, ThrustFrameNo
        LIBSPRITE_SETFRAME_AA ManuoverSpNo, ManuoverFrameNo

        LIBSPRITE_SETPOSITION_AAAA LunaLanderSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ThrustSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA ManuoverSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY
        LIBSPRITE_SETPOSITION_AAAA LunaLanderWindowSpNo, LunaLanderXHi, LunaLanderXLo, LunaLanderY

        rts

glDidWeCollideWithScene
        LIBSPRITE_DIDCOLLIDEWITHDATA_A LunaLanderSpNo
        beq DidNotCollide
        ;lda #2
        ;sta EXTCOL

        lda DemoMode
        cmp #255
        beq DidNotCollide

@ConfirmCollided
        lda #True
        sta CollidedWithBackground

DidNotCollide
        rts

glDebugReadInputAndUpdateVariables

@GetInput
        jsr libInputUpdate

        LIBINPUT_GETHELD GameportLeftMask
        bne @TestRight

        LIBMATH_SUB16BIT_AAA LunaLanderXLo, DemoIncrement, LunaLanderXLo

@TestRight
        LIBINPUT_GETHELD GameportRightMask
        bne @TestUp

        LIBMATH_ADD16BIT_AAA LunaLanderXLo, DemoIncrement, LunaLanderXLo

@TestUp
        LIBINPUT_GETHELD GameportUpMask
        bne @TestDown

        LIBMATH_SUB8BIT_AAA LunaLanderY, DemoIncrement, LunaLanderY

@TestDown
        LIBINPUT_GETHELD GameportDownMask
        bne @TestFire

        LIBMATH_ADD8BIT_AAA LunaLanderY, DemoIncrement, LunaLanderY


@TestFire
        ;LIBINPUT_GETHELD GameportFireMask
        ;bne @NoInput

        lda #19
        jsr krljmp_CHROUT$
        ldx LunaLanderXLo
        lda LunaLanderXHi
        jsr $bdcd

        lda #$20
        jsr krljmp_CHROUT$
        lda #44
        jsr krljmp_CHROUT$

        ldx LunaLanderY
        lda #0
        jsr $bdcd

        lda #$20
        jsr krljmp_CHROUT$
        lda #44
        jsr krljmp_CHROUT$

        ldx CollidedWithBackground
        lda #0
        jsr $bdcd

@NoInput
        rts

glReadInputAndUpdateVariables

        lda FuelBarValue
        cmp FuelTankSize
        bcc @GetInput
        lda FuelTankSize
        sta FuelBarValue
        jmp @FuelRanOut

@GetInput
        jsr libInputUpdate

        LIBINPUT_GETHELD GameportLeftMask
        bne @TestRight

        ;130 IF A = 10 THEN HV = HV + HI : TS = 185 :REM A
        LIBMATH_ADD16BIT_AAA HorizontalVelocityFrac, HorizontalInertiaFrac, HorizontalVelocityFrac
        jsr glSoundSideThrust
        ldx SpriteThrustLeftNo
        stx ManuoverFrameNo
        jsr gmAddFuelConsumption

@TestRight
        LIBINPUT_GETHELD GameportRightMask
        bne @TestFire

        ;120 IF A = 18 THEN HV = HV - HI : TS = 184 : REM D
        LIBMATH_SUB16BIT_AAA HorizontalVelocityFrac, HorizontalInertiaFrac, HorizontalVelocityFrac
        jsr glSoundSideThrust
        ldx SpriteThrustRightNo
        stx ManuoverFrameNo
        jsr gmAddFuelConsumption

@TestFire
        LIBINPUT_GETHELD GameportFireMask
        bne @NoInput

        ;110 IF A = 22 THEN VV = VV - T : TS=183 : 
@FireDetected
        LIBMATH_SUB24BIT_AAA VerticalVelocityFracLo, ThrustFracLo, VerticalVelocityFracLo
        jsr glSoundMainThrust
        ldx SpriteThrustNo
        stx ThrustFrameNo
        jsr gmAddFuelConsumption
        jsr gmAddFuelConsumption
        jmp @GravityByPass

@NoInput
        LIBINPUT_GETHELD GameportNoInputMask
        cmp #GameportNoInputMask
        bne @InputProcessed
@FuelRanOut
        ldx #spNoThrust
        stx ThrustFrameNo
        stx ManuoverFrameNo

        ;200 VV = VV + G : IF VV > 2 THEN VV = 2
@InputProcessed
        ldx GameStatus
        cpx #GF_Dead
        beq @GravityByPass
        LIBMATH_ADD24BIT_AAA VerticalVelocityFracLo, GravityFracLo, VerticalVelocityFracLo

@GravityByPass
        lda VerticalVelocity
        cmp #2
        bne @InputFinish

        lda #1
        sta VerticalVelocity
        lda #0
        sta VerticalVelocityFracLo
        sta VerticalVelocityFracHi

@InputFinish
        rts

glDisableSprites
    LIBSPRITE_ENABLE_AV LunaLanderSpNo, False
    LIBSPRITE_ENABLE_AV ThrustSpNo, False
    LIBSPRITE_ENABLE_AV ManuoverSpNo, False
    LIBSPRITE_ENABLE_AV LunaLanderWindowSpNo, False
    rts

glSoundExplosion
    LIBSOUND_PLAY_VAA 1, soundExplosionHigh, soundExplosionLow
    rts

glSoundSideThrust
    LIBSOUND_PLAY_VAA 1, soundSideThrustHigh, soundSideThrustLow
    rts

glSoundMainThrust
    LIBSOUND_PLAY_VAA 1, soundMainThrustHigh, soundMainThrustLow
    rts

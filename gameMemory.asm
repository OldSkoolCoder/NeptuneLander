;*************************************************************************
;* Game Working Variable Space                                           *
;*************************************************************************

; Binary Fraction Format :-
;     First Byte is Fraction = 1/128 -> 1/2
;     Second Byte is Whole Number

LunaLanderXFrac
        brk

LunaLanderXLo
        brk

LunaLanderXHi
        brk

LunaLanderYFrac
        brk

LunaLanderY
        brk

LunaLanderSpNo
        BYTE 0

LunaLanderColour
        brk

ThrustSpNo
        BYTE 1

ThrustFrameNo
        brk

ThrustColour
        brk

ManuoverSpNo
        BYTE 2

ManuoverFrameNo
        brk

ManuoverColour
        brk

VerticalVelocityFrac
        brk

VerticalVelocity
        brk

GravityFrac
        brk

Gravity
        brk

ThrustFrac
        brk

Thrust
        brk

HorizontalVelocityFrac
        brk

HorizontalVelocity
        brk

HorizontalInertiaFrac
        brk

HorizontalInertia
        brk

GameLoopFrameTracker
        brk

FrameSkipRate
        BYTE 03

CollidedWithBackground
        brk

VerticalBarValue
        brk

FuelBarValueFrac
        brk

FuelBarValue
        brk

ThrustCostFrac
        BYTE 64

ThrustCost
        brk

GameStatus
        brk

        ;80 VV = 0 : G = 3/112 : T = 3/112 : HV = 0 : HI = 1/28
gmSetUpGameVariables
        lda #0
        sta VerticalVelocity
        sta HorizontalVelocity
        sta Gravity
        sta Thrust
        sta HorizontalInertia
        lda #False
        sta CollidedWithBackground

        lda #2
        sta GravityFrac
        lda #4
        sta ThrustFrac
        lda #2
        sta HorizontalInertiaFrac

        lda #8
        sta FuelBarValueFrac
        lda #0
        sta FuelBarValue
        lda #GF_InFlight
        sta GameStatus

        rts

gmAddFuelConsumption
        LIBMATH_ADD16BIT_AAA FuelBarValueFrac, ThrustCostFrac, FuelBarValueFrac
        rts

gmSetUpCustomCharacters
        LIBSCREEN_SETCHARMEMORY 12
        rts


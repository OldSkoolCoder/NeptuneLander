;===============================================================================
; Constants

Black           = 0
White           = 1
Red             = 2
Cyan            = 3 
Purple          = 4
Green           = 5
Blue            = 6
Yellow          = 7
Orange          = 8
Brown           = 9
LightRed        = 10
DarkGray        = 11
MediumGray      = 12
LightGreen      = 13
LightBlue       = 14
LightGray       = 15
SpaceCharacter  = 32

False           = 0
True            = 1

;===============================================================================
; Variables

Operator Calc

ScreenRAMRowStartLow ;  SCREENRAM + 40*0, 40*1, 40*2 ... 40*24
        byte <SCREENRAM,     <SCREENRAM+40,  <SCREENRAM+80
        byte <SCREENRAM+120, <SCREENRAM+160, <SCREENRAM+200
        byte <SCREENRAM+240, <SCREENRAM+280, <SCREENRAM+320
        byte <SCREENRAM+360, <SCREENRAM+400, <SCREENRAM+440
        byte <SCREENRAM+480, <SCREENRAM+520, <SCREENRAM+560
        byte <SCREENRAM+600, <SCREENRAM+640, <SCREENRAM+680
        byte <SCREENRAM+720, <SCREENRAM+760, <SCREENRAM+800
        byte <SCREENRAM+840, <SCREENRAM+880, <SCREENRAM+920
        byte <SCREENRAM+960

ScreenRAMRowStartHigh ;  SCREENRAM + 40*0, 40*1, 40*2 ... 40*24
        byte >SCREENRAM,     >SCREENRAM+40,  >SCREENRAM+80
        byte >SCREENRAM+120, >SCREENRAM+160, >SCREENRAM+200
        byte >SCREENRAM+240, >SCREENRAM+280, >SCREENRAM+320
        byte >SCREENRAM+360, >SCREENRAM+400, >SCREENRAM+440
        byte >SCREENRAM+480, >SCREENRAM+520, >SCREENRAM+560
        byte >SCREENRAM+600, >SCREENRAM+640, >SCREENRAM+680
        byte >SCREENRAM+720, >SCREENRAM+760, >SCREENRAM+800
        byte >SCREENRAM+840, >SCREENRAM+880, >SCREENRAM+920
        byte >SCREENRAM+960

ColorRAMRowStartLow ;  COLORRAM + 40*0, 40*1, 40*2 ... 40*24
        byte <COLORRAM,     <COLORRAM+40,  <COLORRAM+80
        byte <COLORRAM+120, <COLORRAM+160, <COLORRAM+200
        byte <COLORRAM+240, <COLORRAM+280, <COLORRAM+320
        byte <COLORRAM+360, <COLORRAM+400, <COLORRAM+440
        byte <COLORRAM+480, <COLORRAM+520, <COLORRAM+560
        byte <COLORRAM+600, <COLORRAM+640, <COLORRAM+680
        byte <COLORRAM+720, <COLORRAM+760, <COLORRAM+800
        byte <COLORRAM+840, <COLORRAM+880, <COLORRAM+920
        byte <COLORRAM+960

ColorRAMRowStartHigh ;  COLORRAM + 40*0, 40*1, 40*2 ... 40*24
        byte >COLORRAM,     >COLORRAM+40,  >COLORRAM+80
        byte >COLORRAM+120, >COLORRAM+160, >COLORRAM+200
        byte >COLORRAM+240, >COLORRAM+280, >COLORRAM+320
        byte >COLORRAM+360, >COLORRAM+400, >COLORRAM+440
        byte >COLORRAM+480, >COLORRAM+520, >COLORRAM+560
        byte >COLORRAM+600, >COLORRAM+640, >COLORRAM+680
        byte >COLORRAM+720, >COLORRAM+760, >COLORRAM+800
        byte >COLORRAM+840, >COLORRAM+880, >COLORRAM+920
        byte >COLORRAM+960

Operator HiLo

screenColumn        byte 0
screenScrollXValue  byte 0
screenRow           byte 0
screenScrollYValue  byte 0

;===============================================================================
; Macros/Subroutines

defm    LIBSCREEN_DEBUG8BIT_VVA
                        ; /1 = X Position Absolute
                        ; /2 = Y Position Absolute
                        ; /3 = 1st Number Low Byte Pointer
        
        lda #White
        sta $0286       ; set text color
        lda #$20        ; space
        jsr $ffd2       ; print 4 spaces
        jsr $ffd2
        jsr $ffd2
        jsr $ffd2
        ;jsr $E566      ; reset cursor
        ldx #/2         ; Select row 
        ldy #/1         ; Select column 
        jsr $E50C       ; Set cursor 

        lda #0
        ldx /3
        jsr $BDCD       ; print number
        endm

;===============================================================================

defm    LIBSCREEN_DEBUG16BIT_VVAA
                        ; /1 = X Position Absolute
                        ; /2 = Y Position Absolute
                        ; /3 = 1st Number High Byte Pointer
                        ; /4 = 1st Number Low Byte Pointer
        
        lda #White
        sta $0286       ; set text color
        lda #$20        ; space
        jsr $ffd2       ; print 4 spaces
        jsr $ffd2
        jsr $ffd2
        jsr $ffd2
        ;jsr $E566      ; reset cursor
        ldx #/2         ; Select row 
        ldy #/1         ; Select column 
        jsr $E50C       ; Set cursor 

        lda /3
        ldx /4
        jsr $BDCD       ; print number
        endm

;==============================================================================

defm    LIBSCREEN_DRAWTEXT_AAAV ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
                                ; /3 = 0 terminated string (Address)
                                ; /4 = Text Color (Value)

        ldy /2 ; load y position as index into list
        
        lda ScreenRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ScreenRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        ldx #0
@loop   lda /3,X
        cmp #0
        beq @done
        sta (ZeroPageLow),Y
        inx
        iny
        jmp @loop
@done


        ldy /2 ; load y position as index into list
        
        lda ColorRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ColorRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        ldx #0
@loop2  lda /3,X
        cmp #0
        beq @done2
        lda #/4
        sta (ZeroPageLow),Y
        inx
        iny
        jmp @loop2
@done2

        endm

;===============================================================================

defm    LIBSCREEN_DRAWDECIMAL_AAAV ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
                                ; /3 = decimal number 2 nybbles (Address)
                                ; /4 = Text Color (Value)

        ldy /2 ; load y position as index into list
        
        lda ScreenRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ScreenRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        ; get high nybble
        lda /3
        and #$F0
        
        ; convert to ascii
        lsr
        lsr
        lsr
        lsr
        ora #$30

        sta (ZeroPageLow),Y

        ; move along to next screen position
        iny 

        ; get low nybble
        lda /3
        and #$0F

        ; convert to ascii
        ora #$30  

        sta (ZeroPageLow),Y
    

        ; now set the colors
        ldy /2 ; load y position as index into list
        
        lda ColorRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ColorRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        lda #/4
        sta (ZeroPageLow),Y

        ; move along to next screen position
        iny 
        
        sta (ZeroPageLow),Y

        endm

;==============================================================================

defm    LIBSCREEN_GETCHAR  ; /1 = Return character code (Address)
        lda (ZeroPageLow),Y
        sta /1
        endm

;===============================================================================

defm    LIBSCREEN_PIXELTOCHAR_AAVAVAAAA
                                ; /1 = XHighPixels      (Address)
                                ; /2 = XLowPixels       (Address)
                                ; /3 = XAdjust          (Value)
                                ; /4 = YPixels          (Address)
                                ; /5 = YAdjust          (Value)
                                ; /6 = XChar            (Address)
                                ; /7 = XOffset          (Address)
                                ; /8 = YChar            (Address)
                                ; /9 = YOffset          (Address)
                                

        lda /1
        sta ZeroPageParam1
        lda /2
        sta ZeroPageParam2
        lda #/3
        sta ZeroPageParam3
        lda /4
        sta ZeroPageParam4
        lda #/5
        sta ZeroPageParam5
        
        jsr libScreen_PixelToChar

        lda ZeroPageParam6
        sta /6
        lda ZeroPageParam7
        sta /7
        lda ZeroPageParam8
        sta /8
        lda ZeroPageParam9
        sta /9

        endm

libScreen_PixelToChar

        ; subtract XAdjust pixels from XPixels as left of a sprite is first visible at x = 24
        LIBMATH_SUB16BIT_AAVAAA ZeroPageParam1, ZeroPageParam2, 0, ZeroPageParam3, ZeroPageParam6, ZeroPageParam7

        lda ZeroPageParam6
        sta ZeroPageTemp

        ; divide by 8 to get character X
        lda ZeroPageParam7
        lsr A ; divide by 2
        lsr A ; and again = /4
        lsr A ; and again = /8
        sta ZeroPageParam6

        ; AND 7 to get pixel offset X
        lda ZeroPageParam7
        and #7
        sta ZeroPageParam7

        ; Adjust for XHigh
        lda ZeroPageTemp
        beq @nothigh
        LIBMATH_ADD8BIT_AVA ZeroPageParam6, 32, ZeroPageParam6 ; shift across 32 chars

@nothigh
        ; subtract YAdjust pixels from YPixels as top of a sprite is first visible at y = 50
        LIBMATH_SUB8BIT_AAA ZeroPageParam4, ZeroPageParam5, ZeroPageParam9


        ; divide by 8 to get character Y
        lda ZeroPageParam9
        lsr A ; divide by 2
        lsr A ; and again = /4
        lsr A ; and again = /8
        sta ZeroPageParam8

        ; AND 7 to get pixel offset Y
        lda ZeroPageParam9
        and #7
        sta ZeroPageParam9

        rts

;==============================================================================

defm    LIBSCREEN_SCROLLXLEFT_A          ; /1 = update subroutine (Address)

        dec screenScrollXValue
        lda screenScrollXValue
        and #%00000111
        sta screenScrollXValue

        lda SCROLX
        and #%11111000
        ora screenScrollXValue
        sta SCROLX

        lda screenScrollXValue
        cmp #7
        bne @finished

        ; move to next column
        inc screenColumn
        jsr /1 ; call the passed in function to update the screen rows
@finished

        endm

;==============================================================================

defm    LIBSCREEN_SCROLLXRIGHT_A         ; /1 = update subroutine (Address)

        inc screenScrollXValue
        lda screenScrollXValue
        and #%00000111
        sta screenScrollXValue

        lda SCROLX
        and #%11111000
        ora screenScrollXValue
        sta SCROLX

        lda screenScrollXValue
        cmp #0
        bne @finished

        ; move to previous column
        dec screenColumn
        jsr /1 ; call the passed in function to update the screen rows
@finished

        endm

;==============================================================================

defm    LIBSCREEN_SCROLLXRESET_A         ; /1 = update subroutine (Address)

        lda #0
        sta screenColumn
        sta screenScrollXValue

        lda SCROLX
        and #%11111000
        ora screenScrollXValue
        sta SCROLX

        jsr /1 ; call the passed in function to update the screen rows

        endm

;==============================================================================

defm    LIBSCREEN_SETSCROLLXVALUE_A     ; /1 = ScrollX value (Address)

        lda SCROLX
        and #%11111000
        ora /1
        sta SCROLX

        endm

;==============================================================================

defm    LIBSCREEN_SETSCROLLXVALUE_V     ; /1 = ScrollX value (Value)

        lda SCROLX
        and #%11111000
        ora #/1
        sta SCROLX

        endm

;==============================================================================

; Sets 1000 bytes of memory from start address with a value
defm    LIBSCREEN_SET1000       ; /1 = Start  (Address)
                                ; /2 = Number (Value)

        lda #/2                 ; Get number to set
        ldx #250                ; Set loop value
@loop   dex                     ; Step -1
        sta /1,x                ; Set start + x
        sta /1+250,x            ; Set start + 250 + x
        sta /1+500,x            ; Set start + 500 + x
        sta /1+750,x            ; Set start + 750 + x
        bne @loop               ; If x<>0 loop

        endm

;==============================================================================

defm    LIBSCREEN_SET38COLUMNMODE

        lda SCROLX
        and #%11110111 ; clear bit 3
        sta SCROLX

        endm

;==============================================================================

defm    LIBSCREEN_SET40COLUMNMODE

        lda SCROLX
        ora #%00001000 ; set bit 3
        sta SCROLX

        endm

;==============================================================================

defm    LIBSCREEN_SETCHARMEMORY  ; /1 = Character Memory Slot (Value)
        ; point vic (lower 4 bits of $d018)to new character data
        lda VMCSB
        and #%11110000 ; keep higher 4 bits
        ; p208 M Jong book
        ora #/1;$0E ; maps to  $3800 memory address
        sta VMCSB
        endm

;==============================================================================

defm    LIBSCREEN_SETCHAR_V  ; /1 = Character Code (Value)
        lda #/1
        sta (ZeroPageLow),Y
        endm

;==============================================================================

defm    LIBSCREEN_SETCHAR_A  ; /1 = Character Code (Address)
        lda /1
        sta (ZeroPageLow),Y
        endm

;==============================================================================

defm    LIBSCREEN_SETCHARPOSITION_AA    ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
        
        ldy /2 ; load y position as index into list
        
        lda ScreenRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ScreenRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        endm

;==============================================================================

defm    LIBSCREEN_SETCOLORPOSITION_AA   ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
                               
        ldy /2 ; load y position as index into list
        
        lda ColorRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ColorRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        endm

;===============================================================================

; Sets the border and background colors
defm    LIBSCREEN_SETCOLORS     ; /1 = Border Color       (Value)
                                ; /2 = Background Color 0 (Value)
                                ; /3 = Background Color 1 (Value)
                                ; /4 = Background Color 2 (Value)
                                ; /5 = Background Color 3 (Value)
                                
        lda #/1                 ; Color0 -> A
        sta EXTCOL              ; A -> EXTCOL
        lda #/2                 ; Color1 -> A
        sta BGCOL0              ; A -> BGCOL0
        lda #/3                 ; Color2 -> A
        sta BGCOL1              ; A -> BGCOL1
        lda #/4                 ; Color3 -> A
        sta BGCOL2              ; A -> BGCOL2
        lda #/5                 ; Color4 -> A
        sta BGCOL3              ; A -> BGCOL3

        endm

;==============================================================================

defm    LIBSCREEN_SETMULTICOLORMODE

        lda SCROLX
        ora #%00010000 ; set bit 5
        sta SCROLX

        endm

;===============================================================================

; Waits for a given scanline 
defm    LIBSCREEN_WAIT_V        ; /1 = Scanline (Value)

@loop   lda #/1                 ; Scanline -> A
        cmp RASTER              ; Compare A to current raster line
        bne @loop               ; Loop if raster line not reached 255

        endm

;==============================================================================

defm    LIBSCREEN_COPYSCREEN    ; /1 MemoryLocation of Screen To Copy

        ldy #0
@loop
        lda /1,y
        sta COLORRAM,y
        lda /1+250,y
        sta COLORRAM+250,y
        lda /1+500,y
        sta COLORRAM+500,y
        lda /1+750,y
        sta COLORRAM+750,y

        lda /1+1000,y
        sta SCREENRAM,y
        lda /1+1250,y
        sta SCREENRAM+250,y
        lda /1+1500,y
        sta SCREENRAM+500,y
        lda /1+1750,y
        sta SCREENRAM+750,y

        iny
        cpy #250
        bne @loop
        
        endm

;===============================================================================

;==============================================================================

defm    LIBSCREEN_COPYROW    ; /1 MemoryLocation of Screen To Copy

        lda /1,y
        sta /1+40,y
        lda /1+$D400,y
        sta /1+$D428,y
        
        endm

;===============================================================================

;==============================================================================

defm    LIBSCREEN_SCROLLYUP_A          ; /1 = update subroutine (Address)

        dec screenScrollYValue
        lda screenScrollYValue
        and #%00000111
        sta screenScrollYValue

        lda SCROLY
        and #%11111000
        ora screenScrollYValue
        sta SCROLY

        lda screenScrollYValue
        cmp #7
        bne @finished

        ; move to next row
        inc screenRow
        jsr /1 ; call the passed in function to update the screen rows
@finished

        endm

;==============================================================================

defm    LIBSCREEN_SCROLLYDOWN_A         ; /1 = update subroutine (Address)

        ;lda #7
        ;sta $d020
        inc screenScrollYValue
        lda screenScrollYValue
        and #%00000111
        sta screenScrollYValue

@ScrollScreen
        lda SCROLY
        and #%11111000
        ora screenScrollYValue
        sta SCROLY

        lda screenScrollYValue
        cmp #0
        bne @finished

        ; move to previous row
        dec screenRow
        jsr /1 ; call the passed in function to update the screen rows

@finished
        endm

;==============================================================================

defm    LIBSCREEN_SCROLLYRESET_A         ; /1 = update subroutine (Address)

        lda #0
        sta screenRow
        sta screenScrollYValue

        lda SCROLY
        and #%11111000
        ora screenScrollYValue
        sta SCROLY

        jsr /1 ; call the passed in function to update the screen rows

        endm

;==============================================================================

defm    LIBSCREEN_SETSCROLLYVALUE_A     ; /1 = ScrollY value (Address)

        lda SCROLY
        and #%11111000
        ora /1
        sta SCROLY

        endm

;==============================================================================

defm    LIBSCREEN_SETSCROLLYVALUE_V     ; /1 = ScrollY value (Value)

        lda SCROLY
        and #%11111000
        ora #/1
        sta SCROLY

        endm

;==============================================================================

defm    LIBSCREEN_SET24ROWMODE

        lda SCROLY
        and #%11110111 ; clear bit 3
        sta SCROLY

        endm

;==============================================================================

defm    LIBSCREEN_SET25ROWMODE

        lda SCROLY
        ora #%00001000 ; set bit 3
        sta SCROLY

        endm

;==============================================================================

;==============================================================================
; Input Params : Y = Hi Location, Acc = Lo Location

libScreen_CopyMap
    
        sta @Part1+1
        sta @Part2+1
        sta @Part3+1
        sta @Part4+1

        sty @Part1+2
        iny
        sty @Part2+2
        iny
        sty @Part3+2
        iny
        sty @Part4+2

        ldy #0
@loop
@Part1
        lda $1000,y
        sta SCREENRAM,y
@Part2
        lda $1000,y
        sta SCREENRAM+256,y
@Part3
        lda $1000,y
        sta SCREENRAM+512,y
@Part4
        lda $1000,y
        sta SCREENRAM+768,y

        iny
        bne @loop
        rts

;==============================================================================
; Input Parameters : Acc = Colour
;                  : ZeroPageParam5 = X
;                  : ZeroPageParam6 = Y
;                  : ZeroPageParam7 = #

libScreen_SetColour
    pha     ; Push Colour To Stack
    ldy ZeroPageParam6
    lda ColorRAMRowStartLow,y
    sta @RowOne + 1
    lda ColorRAMRowStartHigh,y
    sta @RowOne + 2

    iny
    lda ColorRAMRowStartLow,y
    sta @RowTwo + 1
    lda ColorRAMRowStartHigh,y
    sta @RowTwo + 2

    ldx #0
    ldy ZeroPageParam5
    pla
@Looper
    
@RowOne
    sta $1000,y
@RowTwo
    sta $1000,y
    iny
    inx
    cpx ZeroPageParam7
    bne @Looper

    ; Work Out Y Platform Pixel for sprite
    lda ZeroPageParam6
    asl             ; *2
    asl             ; *4
    asl             ; *8

    clc
    adc #07        ; upto pixel line on base
    adc #50         ; Sprite start Coordinate

    sec
    sbc #21         ; subtract Sprite Height
    sta ZeroPageParam7  ; Final Y Line
    
    ; Work Out X Platform Pixel for sprite
    lda #0
    sta ZeroPageParam6
    lda ZeroPageParam5
    asl             ; *2
    asl             ; *4
    asl             ; *8
    rol ZeroPageParam6

    clc
    adc #24        ; Sprite Start Coordinate
    sta ZeroPageParam5  ; Final X Position

    bcc @DontInc6
    inc ZeroPageParam6

@DontInc6
    rts

;==============================================================================
; Input Params : Acc = Hi Location, Y = Lo Location
libScreen_DecodeMap

    sty @LoadMapByte + 1
    sta @LoadMapByte + 2

    iny
    bne @ByPassHiAddition
    adc #1

@ByPassHiAddition
    sty @LoadMapLength + 1
    sta @LoadMapLength + 2

    lda #<SCREENRAM 
    sta @StoreMap + 1
    lda #>SCREENRAM
    sta @StoreMap + 2

@LoadMapLength
    ldx $BABE
    beq @ExitDecoder

@LoadMapByte
    lda $BEEF

@StoreMap
    sta $B00B

    inc @StoreMap + 1
    bne @GetNextChar
    inc @StoreMap + 2

@GetNextChar
    dex
    bne @StoreMap

    clc
    lda @LoadMapLength + 1
    adc #2
    sta @LoadMapLength + 1
    lda @LoadMapLength + 2
    adc #0
    sta @LoadMapLength + 2

    clc
    lda @LoadMapByte + 1
    adc #2
    sta @LoadMapByte + 1
    lda @LoadMapByte + 2
    adc #0
    sta @LoadMapByte + 2

    jmp @LoadMapLength

@ExitDecoder
    rts
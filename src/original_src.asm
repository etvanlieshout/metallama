;

; **** ZP ABSOLUTE ADRESSES **** 
;
zpLo = $00
zpHi = $01
screenPtrXPos = $02
screenPtrYPos = $03
charToDraw = $04
colorToDraw = $05
a07 = $07
a09 = $09
a0A = $0A
a0B = $0B
a0C = $0C
a0E = $0E
currentPlayerPositionCol = $10
a11 = $11
lastMovementDirection = $12
joystickInput = $13
a14 = $14
previousPlayerPositionCol = $15
a16 = $16
deflexLinePos = $17
a18 = $18
a19 = $19
a1A = $1A
a1B = $1B
a1C = $1C
a1D = $1D
a1E = $1E
a1F = $1F
a20 = $20
a21 = $21
a22 = $22
a23 = $23
a24 = $24
a25 = $25
a26 = $26
a27 = $27
currentLevel = $28
LivesLeft = $29
LastKeyPressed = $C5

;
; **** FIELDS **** 
;
SCREEN_PTR_LO = $0340
SCREEN_PTR_HI = $0360
f037F = $037F
f0383 = $0383
f0384 = $0384
f0387 = $0387
f0388 = $0388
f038B = $038B
f038C = $038C
fC000 = $C000
fC001 = $C001
fC042 = $C042
;
; **** ABSOLUTE ADRESSES **** 
;
a0291 = $0291
a0380 = $0380
a0382 = $0382
a0386 = $0386
SCREEN_RAM = $1E00
a97D9 = $97D9
a97DA = $97DA
a97DB = $97DB
;
; **** POINTERS **** 
;
p03 = $0003
p13 = $0013
p0107 = $0107
p0417 = $0417
p0A00 = $0A00
p0A07 = $0A07
;
; **** PREDEFINED LABELS **** 
;
RAM_CINV = $0314
VICCR4 = $9004
VICCR5 = $9005
VICCRA = $900A
VICCRB = $900B
VICCRC = $900C
VICCRD = $900D
VICCRE = $900E
VICCRF = $900F
VIA1IER = $911E
VIA1PA2 = $911F
VIA2PB = $9120
VIA2DDRB = $9122

        * = $1001

;------------------------------------------------
; SYS 4111 (Launch)
;------------------------------------------------
        .BYTE $0D,$10,$0A,$00,$9E,$28,$34,$31,$31,$31,$29,$00
Launch
        BRK #$00
        JMP SetInterrupts

;------------------------------------------------
; We write to the screen by writing to address $1E00-$1FFF.
; Use SCREEN_PTR_LO/SCREEN_PTR_HI as an array that contains
; pointers to the addresses in screen memory.
;------------------------------------------------
InitScreenPtrArray
        LDA #>SCREEN_RAM
        STA zpHi
        LDA #<SCREEN_RAM
        STA zpLo
        LDX #$00

b101C   LDA zpLo
        STA SCREEN_PTR_LO,X
        LDA zpHi
        STA SCREEN_PTR_HI,X
        LDA zpLo
        CLC 
        ADC #$16
        STA zpLo
        LDA zpHi
        ADC #$00
        STA zpHi
        INX 
        CPX #$1B
        BNE b101C

        RTS 

;------------------------------------------------
; Screen_GetPtr
;------------------------------------------------
Screen_GetPtr
        LDX screenPtrYPos
        LDY screenPtrXPos
        LDA SCREEN_PTR_LO,X
        STA zpLo
        LDA SCREEN_PTR_HI,X
        STA zpHi
        RTS 

;------------------------------------------------
;------------------------------------------------
GetCharacterAtCurrentPos   TXA 
        PHA 
        TYA 
        PHA 
        JSR Screen_GetPtr
        LDA (zpLo),Y
        STA a07
b1053   JMP j1079

;------------------------------------------------
; DrawCharacter
;------------------------------------------------
DrawCharacter
        LDA screenPtrXPos
        AND #$80
        BEQ b105D
        RTS 

b105D   TXA 
        PHA 
        TYA 
        PHA 
        LDA screenPtrXPos
        CMP #$28
        BPL b1053
        JSR Screen_GetPtr
        LDA charToDraw
        STA (zpLo),Y
        LDA zpHi
        CLC 
        ADC #$78
        STA zpHi
        LDA colorToDraw
        STA (zpLo),Y
j1079   PLA 
        TAY 
        PLA 
        TAX 
        LDA a07
        RTS 

;------------------------------------------------
; ClearSreen
;------------------------------------------------
ClearSreen
        LDX #$00
b1082   LDA #$00
        STA SCREEN_RAM,X
        STA SCREEN_RAM + $0100,X
        DEX 
        BNE b1082
        RTS 

;------------------------------------------------
; InitializeAudioAndVideo
;------------------------------------------------
InitializeAudioAndVideo
        JSR InitScreenPtrArray
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        LDA #$00
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        LDA #$FF ; Character set at $1C00
        STA VICCR5   ;$9005 - screen map & character map address
        JSR DrawTitleScreen
        JMP InitializeScoresAndEnterTitleLoop

;------------------------------------------------
; DrawTitleScreen
;------------------------------------------------
DrawTitleScreen
        JSR ClearSreen

        LDA #$01
        STA colorToDraw

        LDA #$14
        STA screenPtrYPos

        LDA #$00
        STA screenPtrXPos

        ; Draw the band across the top of the scores
        LDA #$26 ; See $26 in charset.asm
        STA charToDraw
b10C4   JSR DrawCharacter
        INC screenPtrXPos
        LDA screenPtrXPos
        CMP #$16
        BNE b10C4

        INC screenPtrYPos
        LDA #$07
        STA colorToDraw
        LDX #$00
        STX screenPtrXPos

b10D9   LDA ScoreLineText,X
        STA charToDraw
        JSR DrawCharacter
        INC screenPtrXPos
        INX 
        CPX #$16
        BNE b10D9

        INC screenPtrYPos
        LDA #$08
        STA screenPtrXPos
        LDX #$00
b10F0   LDA QuotaText,X
        STA charToDraw
        JSR DrawCharacter
        INC screenPtrXPos
        INX 
        CPX #$05
        BNE b10F0

        RTS 

QuotaText     .TEXT "<=>00"
ScoreLineText .TEXT "0000000", $00, "*+,000%0000000"
;------------------------------------------------
; InitializeScoresAndEnterTitleLoop
;------------------------------------------------
InitializeScoresAndEnterTitleLoop
        LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        STA a1D

EnterTitleLoop
        LDA #$01
        STA currentLevel
        JSR EnterTitleScreenLoopUntilGameStarts

        ; User has pressed F7 to start game
        LDA #$03
        STA LivesLeft

        ; Initialize the score with zeros
        LDX #$07
        LDA #$30
b112F   STA SCREEN_RAM + $01CD,X
        DEX 
        BNE b112F

StartNewLevel
        LDA currentLevel
        CLC 
        ADC #$10
        STA a25
RestartLevel
        LDA #$0A
        STA currentPlayerPositionCol
        JSR DrawLevelInterstitial
        LDY #$20
        LDX currentLevel

        ; Wait a little
b1147   DEY 
        BEQ b114D
        DEX 
        BNE b1147

b114D   INY 
        TYA 
        STA a26
        STA a1C
        LDA #$01
        STA a11
        STA a1F
        STA lastMovementDirection
        STA a16
        LDA #<p03
        STA deflexLinePos
        LDA #>p03
        STA a18
        LDA #$07
        STA a24

        LDA #$30
        STA SCREEN_RAM + $01D9

        LDA #$FF
        LDX #$04
b1172   STA f037F,X
        DEX 
        BNE b1172

        ; Reset the list of active spiders
        LDX #$16
b117A   STA activeSpiderArray,X
        DEX 
        BNE b117A

        JSR ResetPlayerScore

        LDA currentLevel
        ASL 
        STA a09
        LDA #$C0
        SEC 
        SBC a09
        STA a27
        JMP MainGameLoop

;------------------------------------------------
; GetJoystickInput
;------------------------------------------------
GetJoystickInput
        SEI 
        LDX #$7F
        STX VIA2DDRB ;$9122 - data direction register for port b

b1198   LDY VIA2PB   ;$9120 - port b I/O register
        CPY VIA2PB   ;$9120 - port b I/O register
        BNE b1198

        LDX #$FF
        STX VIA2DDRB ;$9122 - data direction register for port b
        LDX #$F7
        STX VIA2PB   ;$9120 - port b I/O register
        CLI 

b11AB   LDA VIA1PA2  ;$911F - mirror of VIA1PA1 (CA1 & CA2 unaffected)
        CMP VIA1PA2  ;$911F - mirror of VIA1PA1 (CA1 & CA2 unaffected)
        BNE b11AB

        PHA 
        AND #$1C
        LSR 
        CPY #$80
        BCC b11BD
        ORA #$10
b11BD   TAY 
        PLA 
        AND #$20
        CMP #$20
        TYA 
        ROR 
        EOR #$8F
        STA joystickInput
        RTS 

;------------------------------------------------
; MainGameLoop
;------------------------------------------------
MainGameLoop
        JSR DrawPlayerMovement
        JSR UpdateDeflexLine
        JSR UpdateSpiders
        JSR PlayBackgroundMusic
        JSR WaitALittleWhile
        JMP MainGameLoop

;------------------------------------------------
; DrawPlayerMovement
;------------------------------------------------
DrawPlayerMovement
        DEC a14
        BEQ b11E1
        RTS 

b11E1   LDA #$50
        STA a14
        LDA a18
        BEQ b11EB
        DEC a18
b11EB   LDA a11
        BNE DrawOverOldPosition
        LDA currentPlayerPositionCol
        STA previousPlayerPositionCol

        JSR GetJoystickInput

        ; Check for movement left
        LDA joystickInput ; see comment below for how the AND + BEQ work
        AND #$04
        BEQ CheckRight

        ;Move left
        LDA #$00
        STA lastMovementDirection
        DEC currentPlayerPositionCol
        LDA currentPlayerPositionCol
        CMP #$01 ; Should we wrap around?
        BNE CheckRight
        ;Wrap position to the right hand side of the screen.
        LDA #$13
        STA currentPlayerPositionCol

        ;Check for movement right.
CheckRight
        LDA joystickInput ; if joystick input is sw3 (rt), then the AND op
        AND #$08          ; with 0x08 will yeild 0x08, and 0x00 for any other
        BEQ b1222         ; input. BEQ branches on zero
        ;Moved Right
        LDA #$01
        STA lastMovementDirection
        INC currentPlayerPositionCol
        LDA currentPlayerPositionCol
        CMP #$14
        BNE b1222
        LDA #$02
        STA currentPlayerPositionCol

b1222   LDA #$12
        STA screenPtrYPos
        LDA currentPlayerPositionCol
        CMP previousPlayerPositionCol
        BEQ DrawOverOldPosition

        ; Update the player's position
        LDA #$12
        STA screenPtrYPos
        LDA #$01
        STA a11
        LDA previousPlayerPositionCol
        STA screenPtrXPos
        JSR s12A5
        LDA #$05
        STA charToDraw
        LDA lastMovementDirection
        BNE b1247
        LDA #$0F
        STA charToDraw
b1247   LDA currentPlayerPositionCol
        STA screenPtrXPos
        LDA lastMovementDirection
        BEQ b1251
        DEC screenPtrXPos
b1251   JMP j12BE

DrawOverOldPosition
        LDA #$12
        STA screenPtrYPos
        LDA currentPlayerPositionCol
        STA screenPtrXPos
        LDA #$00
        STA a11
        LDA lastMovementDirection
        BEQ b1266
        DEC screenPtrXPos
b1266   JSR ClearOldPosition
        LDA #$01
        STA charToDraw
        LDA lastMovementDirection
        BNE b1275
        LDA #$0B
        STA charToDraw
b1275   LDA currentPlayerPositionCol
        STA screenPtrXPos
        JMP j12F1

ClearOldPosition
        LDA #$00
        STA charToDraw
        JSR DrawCharacter
        LDA screenPtrXPos
        PHA 
        INC screenPtrXPos
        JSR DrawCharacter
        INC screenPtrXPos
        JSR DrawCharacter
        PLA 
        STA screenPtrXPos
        INC screenPtrYPos
        JSR DrawCharacter
        INC screenPtrXPos
        JSR DrawCharacter
        INC screenPtrXPos
        JSR DrawCharacter
        DEC screenPtrYPos
        RTS 

s12A5   LDA #$00
        STA charToDraw
        JSR DrawCharacter
        INC screenPtrXPos
        JSR DrawCharacter
        INC screenPtrYPos
        JSR DrawCharacter
        DEC screenPtrXPos
        JSR DrawCharacter
        DEC screenPtrYPos
        RTS 

j12BE   LDA #$07
        STA colorToDraw
        JSR DrawCharacter
        LDA screenPtrXPos
        PHA 
        INC charToDraw
        INC screenPtrXPos
        JSR DrawCharacter
        INC charToDraw
        INC screenPtrXPos
        JSR DrawCharacter
        PLA 
        STA screenPtrXPos
        INC screenPtrYPos
        INC charToDraw
        JSR DrawCharacter
        INC screenPtrXPos
        INC charToDraw
        JSR DrawCharacter
        INC screenPtrXPos
        INC charToDraw
        JSR DrawCharacter
        DEC screenPtrYPos
        RTS 

j12F1   LDA #$07
        STA colorToDraw
        JSR DrawCharacter
        INC charToDraw
        INC screenPtrXPos
        JSR DrawCharacter
        DEC screenPtrXPos
        INC screenPtrYPos
        INC charToDraw
        JSR DrawCharacter
        INC screenPtrXPos
        INC charToDraw
        JSR DrawCharacter
        DEC screenPtrYPos
        RTS 

;------------------------------------------------
; WaitALittleWhile
;------------------------------------------------
WaitALittleWhile
        LDX #$01
b1314   LDY #$40
b1316   DEY 
        BNE b1316
        DEX 
        BNE b1314
        RTS 

f131D   .BYTE $00
f131E   .BYTE $06,$02,$04,$05,$03,$07,$01
;------------------------------------------------
; UpdateDeflexLine
;------------------------------------------------
UpdateDeflexLine
        DEC a1A
        BEQ b132A
b1329   RTS 

b132A   LDA #$10
        STA a1A
        JSR s13AE
        DEC a16
        BNE b1329
        LDA #$02
        STA a16
        JSR GetJoystickInput


        ; Clear the old line 
        LDA deflexLinePos
        STA screenPtrYPos
        LDA #$00
        STA screenPtrXPos
        STA charToDraw
b1346   JSR GetCharacterAtCurrentPos
        CMP #$1B ; Don't overwrite the spider's web
        BNE b1350
        JSR DrawCharacter
b1350   INC screenPtrXPos
        LDA screenPtrXPos
        CMP #$16
        BNE b1346

        LDA joystickInput
        AND #$01
        BEQ b1368
        DEC deflexLinePos
        LDA deflexLinePos
        CMP #$FF
        BNE b1368
        INC deflexLinePos
b1368   LDA joystickInput
        AND #$02
        BEQ b1378
        INC deflexLinePos
        LDA deflexLinePos
        CMP #$0A
        BNE b1378
        DEC deflexLinePos
b1378   LDA #$00
        STA screenPtrXPos
        LDA #$1B
        STA charToDraw
        LDX a18
        LDA f131E,X
        STA colorToDraw

        LDA deflexLinePos
        STA screenPtrYPos
b138B   JSR GetCharacterAtCurrentPos
        BNE b1393
        JSR DrawCharacter
b1393   INC screenPtrXPos
        LDA screenPtrXPos
        CMP #$16
        BNE b138B

        LDX VICCR4   ;$9004 - raster beam location (bits 7-0)
        LDA fC000,X
        STA a1CDB
        LDA fC001,X
        STA a1CDC
f13AA   RTS 

        .BYTE $07,$03,$06
;------------------------------------------------
; s13AE
;------------------------------------------------
s13AE   LDA a0380
        CMP #$FF
        BEQ b13B8
        JMP j13F9

b13B8   LDA joystickInput
        AND #$80
        BNE b13BF
        RTS 

b13BF   LDX #$03
        LDA #$06
        STA a23
        LDA #$F0
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        LDA #>p0107
        STA a0A
        LDA #<p0107
        STA a09
        JSR s1829
b13D5   LDA #$11
        STA f0383,X
        LDY currentPlayerPositionCol
        LDA lastMovementDirection
        BNE b13E3
        DEY 
        DEY 
        DEY 
b13E3   INY 
        INY 
        TYA 
        STA f037F,X
        LDA lastMovementDirection
        STA f0387,X
        LDA #$00
        STA f038B,X
        DEX 
        BNE b13D5
        JMP j1448

j13F9   LDA a0382
        STA screenPtrXPos
p1400   =*+$02
        LDA a0386
        STA screenPtrYPos
        LDA #$00
        STA charToDraw
        JSR DrawCharacter
        LDX #$02
b140C   LDA f037F,X
        STA a0380,X
        LDA f0383,X
        STA f0384,X
        LDA f0387,X
        STA f0388,X
        LDA f038B,X
        STA f038C,X
        DEX 
        BNE b140C
        LDA a0380
        STA a19
        LDA f0388
        BNE b1437
        DEC a0380
        DEC a0380
b1437   INC a0380
        LDA f038C
        BNE b1445
        DEC f0384
        DEC f0384
b1445   INC f0384
j1448   LDA a0380
        AND #$80
        BNE b1459
        LDA a0380
        CMP #$16
        BEQ b1459
        JMP j1466

b1459   LDA a19
        STA a0380
        LDA f0388
        EOR #$01
        STA f0388
j1466   LDA f0384
        CMP deflexLinePos
        BMI b148C
        JMP j14A3

j1470   LDX #$03
b1472   LDA f037F,X
        STA screenPtrXPos
        LDA f0383,X
        STA screenPtrYPos
        LDA #$00
        STA charToDraw
        JSR DrawCharacter
        LDA #$FF
        STA f037F,X
        DEX 
        BNE b1472
        RTS 

b148C   LDA deflexLinePos
        STA f0384
        LDA #$01
        STA f038C
        LDA #$04
        STA a22
        LDA #$E8
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA #$06
        STA a18
j14A3   LDX #$03
b14A5   LDA f13AA,X
        STA colorToDraw
        LDA f037F,X
        STA screenPtrXPos
        LDA f0383,X
        STA screenPtrYPos
        LDY #$16
        LDA f0387,X
        BNE b14BC
        DEY 
b14BC   LDA f038B,X
        BEQ b14CA
        CPY #$16
        BNE b14C9
        DEY 
        JMP b14CA

b14C9   INY 
b14CA   STY charToDraw
        JSR GetCharacterAtCurrentPos
        JSR s1670
        BNE b14D7
        JMP j1470

b14D7   JSR DrawCharacter
        DEX 
        BNE b14A5
        LDA f0384
        CMP #$13
        BNE b14E7
        JMP j1470

b14E7   RTS 

;------------------------------------------------
; UpdateSpiders
;------------------------------------------------
UpdateSpiders
        DEC a1B
        BEQ b14ED
        RTS 

b14ED   LDA a27
        STA a1B
        LDA a1D31
        ROL 
        ADC #$00
        STA a1D31
        EOR #$FF
        STA a1D32
        JSR s1813
        INC a1F
        INC a1E
        LDA a1F
        AND #$01
        STA a1F
        DEC a1C
        BEQ b1513
        JMP j1543

b1513   LDA a26
        STA a1C
        LDX #$16
b1519   LDA activeSpiderArray,X
        CMP #$FF
        BEQ b1526
        DEX 
        BNE b1519

        JMP j1543

b1526   INC a1D
        LDY a1D
        LDA fC042,Y
        AND #$1F
        CMP #$16
        BPL b1526
        STA activeSpiderArray,X
        LDA #$01
        STA activeWebLengthArray,X
        STA f1BDF,X
        LDA #$00
        STA f1BBF,X

j1543   LDX #$16

b1545   LDA activeSpiderArray,X
        CMP #$FF
        BNE b154F
        JMP j157B

b154F   LDA f1BBF,X
        BNE b155A
        JSR UpdateWeb
        JMP j157B

b155A   CMP #$01
        BNE b1564
        JSR s15D2
        JMP j157B

b1564   CMP #$02
        BNE b156E
        JSR s160E
        JMP j157B

b156E   CMP #$03
        BNE b1578
        JSR s17B9
        JMP j157B

b1578   JSR s1641
j157B   DEX 
        BNE b1545
        RTS 

UpdateWeb
        LDA #$00
        STA screenPtrYPos
        LDA activeSpiderArray,X
        STA screenPtrXPos
        LDA #$04
        STA colorToDraw
        LDA #$17
        STA charToDraw
b1590   JSR DrawCharacter
        INC screenPtrYPos
        LDA screenPtrYPos
        CMP activeWebLengthArray,X
        BNE b1590

        LDA #$1C
        CLC 
        ADC f1BDF,X
        STA charToDraw
        JSR DrawCharacter
        INC f1BDF,X
        LDA f1BDF,X
        AND #$01
        STA f1BDF,X
        BNE b15BE
        INC activeWebLengthArray,X
        LDA activeWebLengthArray,X
        CMP #$0F
        BEQ b15BF
b15BE   RTS 

b15BF   LDA #$01
        STA f1BBF,X
        LDA #$00
        STA f1BDF,X
        DEC activeWebLengthArray,X
f15CC   RTS 

        .BYTE $17,$18,$19,$1A,$00
s15D2   LDA #$00
        STA screenPtrYPos
        LDA activeSpiderArray,X
        STA screenPtrXPos
        INC f1BDF,X
        LDA f1BDF,X
        CMP #$06
        BEQ b1608
        TAY 
        LDA f15CC,Y
        STA charToDraw
        LDA a1E
        AND #$07
        STA colorToDraw
b15F1   JSR DrawCharacter
        INC screenPtrYPos
        LDA screenPtrYPos
        CMP activeWebLengthArray,X
        BNE b15F1
        LDA #$1C
        STA charToDraw
        LDA #$03
        STA colorToDraw
        JMP DrawCharacter

b1608   LDA #$02
        STA f1BBF,X
        RTS 

s160E   LDA activeSpiderArray,X
        STA screenPtrXPos
        LDA activeWebLengthArray,X
        STA screenPtrYPos
        LDA #$00
        STA charToDraw
        JSR s1884
        INC activeWebLengthArray,X
        INC screenPtrYPos
        LDA #$03
        STA colorToDraw
        LDA #$1E
        STA charToDraw
        JSR s1884
        LDA screenPtrYPos
        CMP #$13
        BEQ b1636
        RTS 

b1636   LDA #$03
        STA f1BBF,X
        LDA #$01
        STA f1BDF,X
        RTS 

s1641   LDA activeSpiderArray,X
        STA screenPtrXPos
        LDA activeWebLengthArray,X
        STA screenPtrYPos
        LDA f1BDF,X
        STA charToDraw
        INC f1BBF,X
        LDA f1BBF,X
        AND #$07
        STA colorToDraw
        JSR DrawCharacter
        LDA f1BBF,X
        BEQ b1663
        RTS 

b1663   LDA #$00
        STA charToDraw
        JSR DrawCharacter
        LDA #$FF
        STA activeSpiderArray,X
        RTS 

s1670   CMP #$17
        BNE b16B2
        LDX #$16
b1676   LDA activeSpiderArray,X
        CMP screenPtrXPos
        BEQ b1683
b167D   DEX 
        BNE b1676
        LDA #$00
        RTS 

b1683   LDA f1BBF,X
        BNE b167D
        LDA #$01
        STA f1BBF,X
        LDA #$00
        STA f1BDF,X
        LDA #$08
        STA a24
        LDA #$10
        SEC 
        SBC activeWebLengthArray,X
        CLC 
        ROR 
        CLC 
        STA a0A
        PHA 
        LDA #$05
        STA a09
        JSR s1829
        PLA 
        ADC #$30
        STA SCREEN_RAM + $01D9
        LDA #$00
        RTS 

b16B2   CMP #$1C
        BEQ b16BD
        CMP #$1D
        BEQ b16BD
        JMP j16F3

b16BD   JSR s173C
        LDA #$F0
        STA f1BBF,X
        LDA #$1F
        STA f1BDF,X
        STA charToDraw
        LDA #$01
        JSR s1846
        JSR DrawCharacter
        LDA #$00
        STA charToDraw
        LDA activeSpiderArray,X
        STA screenPtrXPos
        LDA #$00
        STA screenPtrYPos
b16E1   JSR DrawCharacter
        INC screenPtrYPos
        LDA screenPtrYPos
        CMP activeWebLengthArray,X
        BNE b16E1
        JSR s17AF
        LDA #$00
        RTS 

j16F3   CMP #$1E
        BNE b1714
        JSR s173C
        LDA #$F0
        STA f1BBF,X
        LDA #$20
        STA f1BDF,X
        STA charToDraw
        LDA #$04
        JSR s1846
        JSR DrawCharacter
        JSR s17AF
        LDA #$00
        RTS 

b1714   CMP #$28
        BEQ b171F
        CMP #$29
        BEQ b171F
        LDA #$FF
        RTS 

b171F   JSR s173C
        LDA #$F0
        STA f1BBF,X
        LDA #$21
        STA f1BDF,X
        STA charToDraw
        LDA #$06
        JSR s1846
        JSR DrawCharacter
        JSR s17AF
        LDA #$00
        RTS 

s173C   LDX #$16
b173E   LDA activeSpiderArray,X
        CMP screenPtrXPos
        BEQ b174D
b1745   DEX 
        BNE b173E

        PLA 
        PLA 
        LDA #$00
        RTS 

b174D   LDA activeWebLengthArray,X
        CMP screenPtrYPos
        BNE b1745
        RTS 

;------------------------------------------------
; PlayBackgroundMusic
;------------------------------------------------
PlayBackgroundMusic
        DEC a20
        BEQ b175A
        RTS 

b175A   LDA #$10
        STA a20
        LDA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        AND #$80
        BEQ b1773
        INC VICCRA   ;$900A - frequency of sound osc.1 (bass)
        BNE b1773
        DEC a21
        BEQ b1773
        LDA #$F8
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
b1773   LDA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        AND #$80
        BEQ b1794
        DEC VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        CMP #$E0
        BNE b1794
        LDA #$00
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        BNE b1794
        DEC a22
        BEQ b1794
        LDA #$E8
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
b1794   LDA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        AND #$80
        BEQ b17AE
        INC VICCRD   ;$900D - frequency of sound osc.4 (noise)
        LDA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        CMP #$FE
        BNE b17AE
        DEC a23
        BNE b17AE
        LDA #$F0
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
b17AE   RTS 

;------------------------------------------------
; s17AF
;------------------------------------------------
s17AF   LDA #$F8
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        LDA #$04
        STA a21
        RTS 

s17B9   LDA #<p13
        STA screenPtrYPos
        LDA #>p13
        STA charToDraw
        LDA #$03
        STA colorToDraw
        LDA a1F
        BNE b1803
        LDA activeSpiderArray,X
        STA screenPtrXPos
        CMP currentPlayerPositionCol
        BMI b17EA
        JSR s1884
        DEC f1BDF,X
        LDA f1BDF,X
        CMP #$FF
        BNE b1803
        LDA #$01
        STA f1BDF,X
        DEC activeSpiderArray,X
        JMP b1803

b17EA   INC f1BDF,X
        LDA f1BDF,X
        CMP #$02
        BNE b1803
        LDA #$00
        STA charToDraw
        JSR DrawCharacter
        LDA #$00
        STA f1BDF,X
        INC activeSpiderArray,X
b1803   LDA activeSpiderArray,X
        STA screenPtrXPos
        LDA #$29
        SEC 
        SBC f1BDF,X
        STA charToDraw
        JMP s1884

s1813   LDA a24
        BNE b1818
        RTS 

b1818   DEC a24
        LDX a24
        LDA f131D,X
        STA a97D9
        STA a97DA
        STA a97DB
        RTS 

s1829   TXA 
        PHA 
b182B   LDX a09
b182D   INC SCREEN_RAM + $01CD,X
        LDA SCREEN_RAM + $01CD,X
        CMP #$3A
        BNE b183F
        LDA #$30
        STA SCREEN_RAM + $01CD,X
        DEX 
        BNE b182D
b183F   DEC a0A
        BNE b182B
        PLA 
        TAX 
        RTS 

s1846   STA a0A
        LDA #$05
        STA a09
        JSR s1829
        DEC a25
        JSR ResetPlayerScore
        LDA a25
        BEQ b1879
        LDA a25
        AND #$03
        CMP #$03
        BNE b1866
        DEC a26
        BNE b1866
        INC a26
b1866   LDA #$04
        STA a09
b186A   DEC a27
        LDA a27
        CMP #$30
        BNE b1874
        INC a27
b1874   DEC a09
        BNE b186A
        RTS 

b1879   INC currentLevel
        JSR PlayLevelCompleteMusic
        JSR ZeroizeEntireScreen
        JMP StartNewLevel

s1884   JSR GetCharacterAtCurrentPos
        BEQ b1898
        STA a09
        AND #$80
        BNE b1898
        LDA #$14
        CMP a09
        BMI b1898
        JMP PlayerKilled

b1898   JMP DrawCharacter

;------------------------------------------------
; PlayerKilled
;------------------------------------------------
PlayerKilled
        LDA #$00
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA #$80
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
b18AB   LDA #$20
        STA a0A
b18AF   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        CMP #$00
        BNE b18AF
        LDX #$08
        LDA VICCRF   ;$900F - screen colors: background, border & inverse
        CMP #$08
        BNE b18C1
        LDX #$2A
b18C1   STX VICCRF   ;$900F - screen colors: background, border & inverse
        DEC a0A
        BNE b18AF
        DEC VICCRE   ;$900E - sound volume
        BNE b18AB
        LDA #$00
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        LDA #$0F
        STA VICCRE   ;$900E - sound volume

        DEC LivesLeft
        BNE b18DE
        JMP LoadGameOverScreen

b18DE   JSR ZeroizeEntireScreen
        JMP RestartLevel

;------------------------------------------------
; ZeroizeEntireScreen
;------------------------------------------------
ZeroizeEntireScreen
        LDA #$00
        STA screenPtrYPos

RowLoop LDA #$00
        STA screenPtrXPos
        STA charToDraw

ColLoop JSR DrawCharacter
        INC screenPtrXPos
        LDA screenPtrXPos
        CMP #$16
        BNE ColLoop

        INC screenPtrYPos
        LDA screenPtrYPos
        CMP #$14
        BNE RowLoop
        RTS 

;------------------------------------------------
; PlayLevelCompleteMusic
;------------------------------------------------
PlayLevelCompleteMusic
        LDA #$00
        STA VICCR4   ;$9004 - raster beam location (bits 7-0)
        STA a0A
        STA a0B
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
j1914   INC a0B
        LDA a0B
        AND #$07
        TAX 
        LDA f131D,X
        AND #$0F
        ORA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        LDY #$30
b1927   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        BEQ b1932
        DEY 
        BNE b1927
        JMP j1914

b1932   LDA #$00
        STA a0B
        LDA a0A
        ASL 
        ASL 
        ASL 
        ORA #$80
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        DEC a0A
        BNE j1914
        LDA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        RTS 

;------------------------------------------------
; EnterTitleScreenLoopUntilGameStarts
;------------------------------------------------
EnterTitleScreenLoopUntilGameStarts
        JSR ZeroizeEntireScreen
        LDA #>p0A00
        STA screenPtrYPos
        LDA #<p0A00
        STA screenPtrXPos
        TAX 
b1959   LDA TextTitleLine2,X
        AND #$3F
        ORA #$80
        STA charToDraw
        LDA #$01
        STA colorToDraw
        JSR DrawCharacter
        LDA #$06
        STA screenPtrYPos
        LDA CopyrightLine,X
        AND #$3F
        ORA #$80
        STA charToDraw
        JSR DrawCharacter
        LDA #$0A
        STA screenPtrYPos
        INC screenPtrXPos
        INX 
        CPX #$16
        BNE b1959
        JSR DrawCurrentLevelOnScreen
        LDA #$00
        STA a0A
        STA a0C

OuterTitleLoop
        LDA a0C
        STA a0B

        ; Title screen loop, wait for the player to press something.
TitleWaitForInput
        INC a0B
        LDA a0B
        AND #$07
        TAX 
        ; Flash the screen borders
        LDA f131D,X
        ORA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        LDY a0B
b19A2   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        BEQ CycleColors ; Cycle around the colors

        LDA LastKeyPressed
        CMP #$40
        BNE b19D6

b19AD   DEY 
        BNE b19A2
        JMP TitleWaitForInput

CycleColors
        DEC a0A
        BNE OuterTitleLoop
        LDA #$05
        STA a0A
        INC a0C
        JMP OuterTitleLoop

TextTitleLine2   .TEXT "F1:LEVEL 00   F7:BEGIN"
b19D6   CMP #$27 ; F1 Pressed
        BEQ IncrementSelectedLevel
        CMP #$3F
        BNE b19AD
        LDA #$08 ; F8 Pressed
        JMP ClearScreenandReturntoGameLoop

CopyrightLine   .TEXT "(C)  1983    LLAMASOFT"
IncrementSelectedLevel
        INC currentLevel
        LDA currentLevel
        CMP #$21
        BNE b1A05
        LDA #$01
        STA currentLevel
b1A05   JSR DrawCurrentLevelOnScreen
        LDA #$30
        STA a0E
b1A0C   LDX #$00
b1A0E   LDA a0E
        ORA #$80
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        DEX 
        BNE b1A0E
        DEC a0E
        BNE b1A0C
        LDA #$00
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        JMP b19AD

;------------------------------------------------
; DrawCurrentLevelOnScreen
;------------------------------------------------
DrawCurrentLevelOnScreen
        LDA #$30
        STA SCREEN_RAM + $00E5
        STA SCREEN_RAM + $00E6
        LDX currentLevel
b1A2E   INC SCREEN_RAM + $00E6
        LDA SCREEN_RAM + $00E6
        CMP #$3A
        BNE b1A40
        LDA #$30
        STA SCREEN_RAM + $00E6
        INC SCREEN_RAM + $00E5
b1A40   DEX 
        BNE b1A2E
        RTS 

;------------------------------------------------
; DrawLevelInterstitial
;------------------------------------------------
DrawLevelInterstitial
        JSR ZeroizeEntireScreen
        LDA #>p0A00
        STA screenPtrYPos
        LDA #<p0A00
        STA screenPtrXPos
        TAX 
        LDA #$07
        STA colorToDraw
b1A54   LDA LevelInterstitialText,X
        AND #$3F
        ORA #$80
        STA charToDraw
        JSR DrawCharacter
        INC screenPtrXPos
        INX 
        CPX #$16
        BNE b1A54
        JSR DrawCurrentLevelOnScreen
        LDA #$30
        CLC 
        ADC LivesLeft
        STA SCREEN_RAM + $00F1
b1A72   LDX #$30
b1A74   LDA fC000,X
        ORA #$80
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDA #$03
        STA a0A
        LDY #$00
b1A82   DEY 
        BNE b1A82
        DEC a0A
        BNE b1A82
        DEX 
        BNE b1A74
        DEC VICCRE   ;$900E - sound volume
        BNE b1A72
        LDA #$00
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        JMP ZeroizeEntireScreen

LevelInterstitialText   .TEXT "AT LEVEL 00   LLAMAS:0"
;------------------------------------------------
; LoadGameOverScreen
;------------------------------------------------
LoadGameOverScreen
        LDX #$F8
        TXS 
        JSR s1B34
        JSR ZeroizeEntireScreen
        LDA #>p0A07
        STA screenPtrYPos
        LDA #<p0A07
        STA screenPtrXPos
        LDX #$00
b1AC7   LDA GameOverText,X
        AND #$3F
        ORA #$80
        STA charToDraw
        LDA #$03
        STA colorToDraw
        JSR DrawCharacter
        INC screenPtrXPos
        INX 
        CPX #$09
        BNE b1AC7
b1ADE   LDA #$80
        STA a0A
b1AE2   LDA a0A
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
b1AE7   LDY #$08
b1AE9   DEY 
        BNE b1AE9
        INC VICCRA   ;$900A - frequency of sound osc.1 (bass)
        BNE b1AE7
        INC a0A
        BNE b1AE2
        DEC VICCRE   ;$900E - sound volume
        BNE b1ADE
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        JSR ZeroizeEntireScreen
        JMP EnterTitleLoop

GameOverText   .TEXT "GAME OVER"
;------------------------------------------------
; ResetPlayerScore
;------------------------------------------------
ResetPlayerScore
        LDA #$30
        STA SCREEN_RAM + $01EF
        STA SCREEN_RAM + $01F0
        LDA a25
        STA a0E
        BNE b1B1D
        RTS 

b1B1D   INC SCREEN_RAM + $01F0
        LDA SCREEN_RAM + $01F0
        CMP #$3A
        BNE b1B2F
        LDA #$30
        STA SCREEN_RAM + $01F0
        INC SCREEN_RAM + $01EF
b1B2F   DEC a0E
        BNE b1B1D
        RTS 

s1B34   LDX #$01
b1B36   LDA SCREEN_RAM + $01CD,X
        CMP SCREEN_RAM + $01DC,X
        BMI b1B48
        BEQ b1B43
        JMP j1B49

b1B43   INX 
        CPX #$08
        BNE b1B36
b1B48   RTS 

j1B49   LDX #$07
b1B4B   LDA SCREEN_RAM + $01CD,X
        STA SCREEN_RAM + $01DC,X
        DEX 
        BNE b1B4B
        RTS 

;------------------------------------------------
; SetInterrupts
;------------------------------------------------
SetInterrupts
        LDA #$C2
        STA RAM_CINV
        LDA #$80
        STA a0291
        LDA #$02
        STA VIA1IER  ;$911E - interrupt enable register (IER)
        JMP InitializeAudioAndVideo

        RTS 

        .BYTE $48,$98,$48,$8D,$02,$09,$8A,$8D

ClearScreenandReturntoGameLoop
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        JMP ZeroizeEntireScreen ; Ends with an RTS so returns

        .BYTE $8D,$04,$09,$A5,$07,$8D,$05,$09
        .BYTE $68
activeSpiderArray   .BYTE $8D,$33,$A3,$39,$E4,$13,$F5,$BB
        .BYTE $FB,$61,$E5,$5A,$87,$3B,$E9,$33
        .BYTE $C3,$8C,$E2,$C4,$CA,$CE,$CB,$9C
        .BYTE $CD,$C1,$4E,$DD,$C7,$8C
        .BYTE $60,$4D
activeWebLengthArray   .BYTE $D6,$CC,$C8,$C8,$8C,$5F,$FD,$A8
        .BYTE $8F,$CD,$CD,$8F,$C6,$BC,$1C,$CC
        .BYTE $DC,$3D,$AB,$37,$9D,$1B,$CD,$32
        .BYTE $AA,$32,$57,$31,$0A,$2D,$1D,$7D
f1BBF   .BYTE $D8,$1D,$2B,$3B,$93,$3B,$47,$B3
        .BYTE $18,$39,$9F,$A2,$AE,$33,$92,$16
        .BYTE $DA,$EC,$D8,$C8,$CC,$CD,$C6,$C7
        .BYTE $CD,$4C,$CB,$8C,$CD,$4C,$CB,$CC
f1BDF   .BYTE $6D,$CC,$8A,$CC,$4E,$0C,$9C,$AC
        .BYTE $25,$48,$BF,$CC,$CC,$DE,$CC,$D8
        .BYTE $EA,$28,$69,$32,$DF,$38,$FB,$1B
        .BYTE $B2,$32,$FB,$22,$C1,$71,$0A,$35
        .BYTE $0E

.include "charset.asm"
        .BYTE $00
